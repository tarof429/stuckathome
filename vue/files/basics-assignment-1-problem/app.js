const app = Vue.createApp({
    data() {
        return {
            name: 'Dave',
            age: 25,
            image_link: 'https://www.mozilla.org/media/protocol/img/logos/firefox/browser/logo-word-hor.7ff44b5b4194.svg'
        };
    },

    methods: {
        favorite_number() {
            const randomNumber = Math.random();
            return Math.floor(randomNumber * 100) / 100;
        },

        age_in_five_years() {
            return this.age + 5;
        }
    }
});

app.mount('#assignment');