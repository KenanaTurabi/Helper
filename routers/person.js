const express = require('express')
const router = new express.Router()
const mongoose= require('mongoose')
const Person=require('../models/Person')


// Change the route to "/Person/add" for the PUT method
router.put("/Person/add", async (req, res) => {
    console.log("PUT request received at /Person/add");

    const person = new Person(req.body);
    try {
        await person.save();  
        res.status(201).send({ person });
    } catch (e) {
        res.status(400).send(e);
    }
});

// Correct the route for the GET method, and use findById instead of findOne
router.get('/Person/:id', async (req, res) => {
    try {
        let person = await Person.findOne({ id: req.params.id });
        if (!person) {
            return res.status(404).send({ error: 'Person not found' });
        }
        res.send(person);
    } catch (e) {
        res.status(500).send(e);
    }
});


module.exports = router;
