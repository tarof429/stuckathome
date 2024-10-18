const app = Vue.createApp({
    data() {
        return {
          status: '',
          sid: '',
          hostname: '',
          confirmedHostname: '',
          ip: '',
          mac: '',

        };
      },

      methods: { 
        save() {
          if (this.hostname == '' || this.hostname == 'localhost') {
            this.status =  'Unable to save';
          } else {
            this.status = 'Saved';
          }
        },

        reset() {
          this.sid = '';
          this.hostname = '';
          this.confirmedHostname = '';
          this.ip = '';
          this.mac = '';
          this.status = '';
        },

        setHostname(event) {
          this.hostname = event.target.value;
        },
      },

      computed: {
        computedId() {
          if (this.hostname == '' || this.hostname == 'localhost') {
            return '';
          }

          return this.hostname;
        },


      },

      watch: {
        hostname(value) {
          if  (value == 'localhost') {
            this.status = 'Hostname cannot be localhost';
          } else {
            this.status = '';
          }
        }
      }
        
});

app.mount('#system');