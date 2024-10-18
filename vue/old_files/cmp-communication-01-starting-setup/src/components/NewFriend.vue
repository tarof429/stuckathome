<template>

    <!-- Don't forget to use v-model for the fields so we can connect them to data -->
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
            <button>Add Contact</button>
        </div>
    </form>
</template>

<script>
// Define the configuration for this component
export default {

    emits: ["add-contact", "check-if-friend-already-exists"],

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
    }
};
</script> 