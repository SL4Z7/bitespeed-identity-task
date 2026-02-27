const express = require('express');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

// Health Check Route
app.get('/', (req, res) => {
  res.status(200).json({
    status: "Online",
    message: "Bitespeed Identity Reconciliation API is running perfectly!",
    documentation: "Please send POST requests to the /identify endpoint."
  });
});

app.post('/identify', async (req, res) => {
    try {
        const { email, phoneNumber } = req.body;

        if (!email && !phoneNumber) {
            return res.status(400).json({ error: 'Either email or phoneNumber is required.' });
        }

        // Ensure they are strings, ignoring types
        const emailStr = email ? String(email) : undefined;
        const phoneStr = phoneNumber ? String(phoneNumber) : undefined;

        // 1. Find all contacts matching either email or phoneNumber
        const orConditions = [];
        if (emailStr) orConditions.push({ email: emailStr });
        if (phoneStr) orConditions.push({ phoneNumber: phoneStr });

        const matchedContacts = await prisma.contact.findMany({
            where: { OR: orConditions },
            orderBy: { createdAt: 'asc' }
        });

        // Scenario A: Completely New Customer
        if (matchedContacts.length === 0) {
            const newContact = await prisma.contact.create({
                data: {
                    email: emailStr || null,
                    phoneNumber: phoneStr || null,
                    linkPrecedence: 'primary'
                }
            });

            return res.status(200).json({
                contact: {
                    primaryContatctId: newContact.id, // Keeping typo requested exactly
                    emails: newContact.email ? [newContact.email] : [],
                    phoneNumbers: newContact.phoneNumber ? [newContact.phoneNumber] : [],
                    secondaryContactIds: []
                }
            });
        }

        // 2. Existing Customer(s) - gather all related identifiers across networks
        // Find all unique primary IDs involved. Even if a matched contact is secondary, 
        // we trace back to its primary via 'linkedId'.
        const primaryIds = new Set();
        for (const c of matchedContacts) {
            if (c.linkPrecedence === 'primary') {
                primaryIds.add(c.id);
            } else if (c.linkedId) {
                primaryIds.add(c.linkedId);
            }
        }

        // 3. Fetch the full network of contacts (the primaries and ALL their secondaries)
        const primaryIdArr = Array.from(primaryIds);
        let allRelatedContacts = await prisma.contact.findMany({
            where: {
                OR: [
                    { id: { in: primaryIdArr } },
                    { linkedId: { in: primaryIdArr } }
                ]
            },
            orderBy: { createdAt: 'asc' }
        });

        // Determine the true absolute primary (the oldest contact among all related)
        const oldestContact = allRelatedContacts[0];
        const truePrimaryId = oldestContact.id;

        // Scenario D: Merging Two Existing Primary Contacts
        // If we matched multiple separate primary groups, merge the newer ones into the oldest one.
        const primariesToMerge = allRelatedContacts.filter(
            c => c.id !== truePrimaryId && c.linkPrecedence === 'primary'
        );

        if (primariesToMerge.length > 0) {
            const mergeIds = primariesToMerge.map(c => c.id);

            // Convert newer primaries to secondaries
            await prisma.contact.updateMany({
                where: { id: { in: mergeIds } },
                data: {
                    linkPrecedence: 'secondary',
                    linkedId: truePrimaryId,
                    updatedAt: new Date()
                }
            });

            // Also ensure any secondaries that pointed to the newer primaries now point to the true primary
            await prisma.contact.updateMany({
                where: { linkedId: { in: mergeIds } },
                data: {
                    linkedId: truePrimaryId,
                    updatedAt: new Date()
                }
            });

            // Re-fetch all related contacts to have updated state
            allRelatedContacts = await prisma.contact.findMany({
                where: {
                    OR: [
                        { id: truePrimaryId },
                        { linkedId: truePrimaryId }
                    ]
                },
                orderBy: { createdAt: 'asc' }
            });
        }

        // Scenario C: Existing Customer, New Information (Creating a Secondary)
        // Check if the exact email or exact phone number already exists in this family network.
        const existingEmails = new Set(allRelatedContacts.map(c => c.email).filter(Boolean));
        const existingPhones = new Set(allRelatedContacts.map(c => c.phoneNumber).filter(Boolean));

        const isNewEmail = emailStr && !existingEmails.has(emailStr);
        const isNewPhone = phoneStr && !existingPhones.has(phoneStr);

        if (isNewEmail || isNewPhone) {
            const newlyCreatedSecondary = await prisma.contact.create({
                data: {
                    email: emailStr || null,
                    phoneNumber: phoneStr || null,
                    linkedId: truePrimaryId,
                    linkPrecedence: 'secondary'
                }
            });
            allRelatedContacts.push(newlyCreatedSecondary);
        }

        // 4. Formatting the Output
        // Ensure primary contact details are first in the list
        const primaryContact = allRelatedContacts.find(c => c.id === truePrimaryId);

        const responseEmailsSet = new Set();
        if (primaryContact.email) responseEmailsSet.add(primaryContact.email);

        const responsePhonesSet = new Set();
        if (primaryContact.phoneNumber) responsePhonesSet.add(primaryContact.phoneNumber);

        for (const c of allRelatedContacts) {
            if (c.email) responseEmailsSet.add(c.email);
            if (c.phoneNumber) responsePhonesSet.add(c.phoneNumber);
        }

        const secondaryIds = allRelatedContacts.filter(c => c.id !== truePrimaryId).map(c => c.id);

        return res.status(200).json({
            contact: {
                primaryContatctId: truePrimaryId, // Exact match to requested spelling
                emails: Array.from(responseEmailsSet),
                phoneNumbers: Array.from(responsePhonesSet),
                secondaryContactIds: secondaryIds
            }
        });

    } catch (error) {
        console.error('Error during identity reconciliation:', error);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Identity Reconciliation Service running with MySQL on port ${PORT}`);
});
