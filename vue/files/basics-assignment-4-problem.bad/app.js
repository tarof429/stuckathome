const app = Vue.createApp({
    data() {
        return {
            user1Selected: false,
            user2Selected: false
        }
    },


    methods: {
        styler(value) {
            if (value === 'user1') {
                this.user1Selected = !this.user1Selected;
            } else if (value === 'user2') {
                this.user2Selected = !this.user2Selected;
            }
        }
    },
    computed: {
        user1Classes() {
            return { user1: this.user1Selected }; 
        },

        user2Classes() {
            return { user2: this.user2Selected };  
        }
    }
});

app.mount('#assignment');

