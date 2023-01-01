const app = Vue.createApp({
    data() {
      return {
        userInput: '',
        confirmedUserInput: ''
      };
    },
    methods: {
  
      setUserInput(event) {
        this.userInput = event.target.value;
      },

      confirmInput() {
        this.confirmedUserInput = this.userInput;
      },
  
  
      showAlert() {
        alert('Submitted');
      }
      
  }});
  
  app.mount('#assignment');
  