document.getElementById("item").style.cursor = "pointer";

const app = Vue.createApp({
    data() {
        return {
            task: '',
            tasks: [],
            tasksVisible: true,
        }
    },

    methods: {
        addTask() {
            this.tasks.push(this.task);
        },
        
        removeTask(index) {
            this.tasks.splice(index, 1);
        },

        showTasks() {
            this.tasksVisible = !this.tasksVisible;
        },
    },

    computed: {
        showOrHideTask() {
            return this.tasksVisible ? 'Hide' : 'Show';
        }
    }

});

app.mount('#assignment');
