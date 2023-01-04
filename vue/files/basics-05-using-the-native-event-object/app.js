const app = Vue.createApp({
  data() {
    return {
      counter: 0,
      name: ''
    };
  },
  methods: {
    setName(event, lastName) {
      this.name = event.target.value;
    },
    add(num) {
      this.counter = this.counter + num;
    },
    reduce(num) {
      this.counter = this.counter - num;
      // this.counter--;
    },
    reset() {
      this.name = '';
    }
  },
  computed: {
    fullname() {
      console.log('Running fullname()');
      if (this.name == '') {
        return '';
      }
      return this.name + ' ' + 'The Man';
    }
  },

  watch: {
    counter(value) {
      if (value > 50) {
        this.counter = 0;
      }
    }
  }
});

app.mount('#events');
