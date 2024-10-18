document.getElementById("item").style.cursor = "pointer";

const app = Vue.createApp({
  data() {
    return { 
      goal: '',
      goals: [],
    };
  },

  methods: {
    addGoal() {
      this.goals.push(this.goal);
    },

    removeGoal(index) {
      this.goals.splice(index, 1);
    }

  }
});

app.mount('#user-goals');

