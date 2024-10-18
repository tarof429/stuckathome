<template>
  <section>
    <header>
      <h1>User Management</h1>
    </header>
    <p class="error" v-if="!activeUserValid">{{ validMessage }}</p>
    <!-- Listen to a custom event using v-on and provide the name fo the callback method-->
    <user-data
        @add-user="addNewUser"
    ></user-data>

    <header>
        <h1>Active User</h1>
    </header>
    <active-user
        :userName="activeUser.userName"
        :userAge="activeUser.userAge"
    >
    </active-user>
    </section>

</template>

<script>
export default {
    data() {
        return {
            activeUser: {
                userName: "Manual",
                userAge: "31",
            },
            validMessage: "Both fields are required",
            activeUserValid: true
        };
    },
  
    methods: {
        addNewUser(enteredUserName, enteredUserAge) {
            console.log('Adding a user ' + enteredUserName + ' with age ' + enteredUserAge);

            if (enteredUserName == "" || enteredUserAge == "") {
                this.activeUserValid = false;
                return;
            }
            this.activeUserValid = true;
            const newUser = {
                userName: enteredUserName, 
                userAge: enteredUserAge, 
            };

            this.activeUser = newUser;
        }
    }
  };
</script>

<style>
* {
  box-sizing: border-box;
}
html {
  font-family: "Jost", sans-serif;
}
body {
  margin: 0;
}
header {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);
  margin: 3rem auto;
  border-radius: 10px;
  padding: 1rem;
  background-color: #58004d;
  color: white;
  text-align: center;
  width: 90%;
  max-width: 40rem;
}
#app ul {
  margin: 0;
  padding: 0;
  list-style: none;
}

#app p,
#app li,
#app form {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);
  margin: 1rem auto;
  border-radius: 10px;
  padding: 1rem;
  text-align: center;
  width: 90%;
  max-width: 40rem;
}

#app p.error {
  font-weight: bold;
  color: #ec3169;
}
#app h2 {
  font-size: 2rem;
  border-bottom: 4px solid #ccc;
  color: #58004d;
  margin: 0 0 1rem 0;
}
#app button {
  font: inherit;
  cursor: pointer;
  border: 1px solid #ff0077;
  background-color: #ff0077;
  color: white;
  padding: 0.05rem 1rem;
  box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.26);
}
#app button:hover,
#app button:active {
  background-color: #ec3169;
  border-color: #ec3169;
  box-shadow: 1px 1px 4px rgba(0, 0, 0, 0.26);
}

#app input {
  font: inherit;
  padding: 0.15rem;
}

#app label {
  font-weight: bold;
  margin-right: 1rem;
  width: 7rem;
  display: inline-block;
}

#app form div {
  margin: 1rem 0;
}

</style>