<template>

    <!-- Don't forget to use v-model here -->
    <!-- Add @submit.prevent="" to we let Vue handle the form submission-->
    <form @submit.prevent="submitData">
        <h2>Add a new friend</h2>
        <div>
            <label>Name </label>
             <input type="text" v-model="enteredName"/>
        </div>
        <div>
            <label>Phone </label>
            <input type="tel" v-model="enteredPhone">
        </div>
        <div>
            <label>Email </label>
            <input type="email" v-model="enteredEmail">
        </div>
        <div>
            <button @click=addFriend>Add Contact</button>
        </div>
    </form>
</template>

<script>
// Define the configuration for this component
export default {
    // Not needed because we dont' get anything from the parent
    // props: {
    //     //id: { type: String, required: true},
    //     name: { type: String, required: true},
    //     phoneNumber: { type: String, required: true},
    //     emailAddress: { type: String, required: true},
    // },

    emits: ["add-contact"],

    data() {
        return {
            enteredName: '',
            enteredPhone: '',
            enteredEmail: ''
        };
    },
    methods: {
        submitData() {
            this.$emit('add-contact', this.enteredName, this.enteredPhone, this.enteredEmail); 
        },
        // We don't need this?
        // addFriend() {
        //     //this.$emit('add-friend', this.enteredName, this.enteredPhone, this.enteredEmail); 
        // }
    }

};
</script> 