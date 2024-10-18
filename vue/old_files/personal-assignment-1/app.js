const app = Vue.createApp({
    data() {
        return {
          savemessage: 'Saved',
          hostname: '',
          confirmedHostname: '',
          status: ''
        };
      },

      methods: {  
        setHostname(event) {
            this.hostname = event.target.value;
        },

        setConfirmedHostname() {
          this.confirmedHostname = this.hostname;
        },

        save() {
          this.status = this.savemessage;
        }
      }
        
});

app.mount('#system');