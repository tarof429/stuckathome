Vue.createApp({
  data() {
    return {
      servers: [],
      id: 0,
    }
  },
  methods: {
    numberOfServers() {
      return this.servers.length;
    },
    getUptime() {
      const randomNumber = Math.random();
      return Math.floor(Math.random() * 60);
    },
    getServerStatus() {
      const randomNumber = Math.random();
      if (randomNumber < 0.1) {
        return '<img src="down.png">';
      } else {
        return '<img src="up.png">';
      }
    },
    getServer() {
      uptime = this.getUptime()
      if (uptime < 10) {
        uptimeValue = '23:32:0' + uptime;
      } else {
        uptimeValue = '23:32:' + uptime;
      }

      return {
        id: this.id,
        hostname: 'db-' + this.id,
        ip: '10.10.4.' + this.id,
        os: 'Ubuntu 22',
        uptime: uptimeValue,
        serverStatus: this.getServerStatus(),
      }
    },
    scan() {
      this.servers = [];
      this.id = 0;

      for (i = 0; i < 10; i++) {
        server = this.getServer()
        this.servers.push(server);
        this.id++;
      }
    },
  }

  }).mount('#app');

  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }