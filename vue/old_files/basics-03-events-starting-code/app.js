const app = Vue.createApp({
  data() {
    return {
      counter: 0,
      name: ''
    };
  },
  methods: {
    increment(num) {
      this.counter = this.counter + num;
    },

    decrement(num) {
      this.counter = this.counter - num;
    },

    setName(event, name) {
      this.name = event.target.value + ' ' + name;
    },

    submitForm() {
      alert('Submitted');
    }
    
}});

app.mount('#events');
