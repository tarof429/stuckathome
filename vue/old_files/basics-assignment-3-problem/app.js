const app = Vue.createApp(
    {
        data() {
            return {
                result: 0,
                message: ''
            };
        },

          
        methods: { 
            add5() {
                this.result = this.result + 5;
            },   

            add1() {
                this.result = this.result + 1;

            }
        },

        watch: {
            result(value) {
              if  (value < 37) {
                this.status = 'Not there yet';
              } else if (value == 37) {
                this.status = 'Correct!';

              } else if (value > 37) {
  
                this.status = 'Too much!';

                const that = this;

                setTimeout(function() {
                    that.result = 0;
                }, 2000);

              }
            }
          }
    }
);

app.mount('#assignment');
