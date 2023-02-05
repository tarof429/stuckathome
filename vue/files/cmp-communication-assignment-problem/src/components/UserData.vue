<template>
    <form @submit.prevent="submitUser">
        <h2>Add a new user</h2>
        <div>
            <label>User name:</label>
             <input type="text" v-model="enteredUser"/>
        </div>
        <div>
            <label>Age:</label>
            <input type="text" v-model="enteredAge">
        </div>
        <div>
            <button>Add User</button>
        </div>
    </form>
</template>

<script>
export default {
    emits: ["add-user"],

    data() {
        return {
            enteredUser: '',
            enteredAge: '',
        };
    },
    methods: {
        submitUser() {
            console.log('submitUser()');
            this.$emit('add-user', this.enteredUser, this.enteredAge); 
        },
    }
}
</script>
