const app = Vue.createApp(
    {
        data() {
            return {
                enteredClass: '',
                username: '',
                password: ''
            }
        },

        computed: {
            setStyle() {
                return {
                    user1: this.enteredClass === 'user1',
                    user2: this.enteredClass === 'user2'
                }
            },
            setUsernameStyle() {
                return {
                    red: this.username.length < 5,
                    gray: this.username.length >= 5
                }
            }

        }

    }
);

app.mount('#assignment');

