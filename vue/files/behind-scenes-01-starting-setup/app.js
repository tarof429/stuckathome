const app = Vue.createApp({
  data() {
    return {
      currentUserInput: '',
      message: 'Vue is great!',
    };
  },
  methods: {
    saveInput(event) {
      this.currentUserInput = event.target.value;
    },
    setText() {
      //this.message = this.currentUserInput;
      this.message = this.$refs.userInput.value;
      //console.log(this.$refs.userInput);
    },
  },

  beforeCreate() {
    console.log('beforeCreate()')
  }
});

app.mount('#app');
