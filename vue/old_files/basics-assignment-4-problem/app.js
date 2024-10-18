const app = Vue.createApp(
    {
        data() {
            return {
                enteredClass: '',
                isVisible: true,
                inputBackgroundColor: ''
            }
        },

        computed: {
            setStyle() {
                return {
                    user1: this.enteredClass === 'user1',
                    user2: this.enteredClass === 'user2',
                    visible: this.isVisible,
                    hidden: !this.isVisible
                }
            }
        },

        methods: {
            showOrHide() {
                this.isVisible = !this.isVisible;
            }
        }
    }
);

app.mount('#assignment');