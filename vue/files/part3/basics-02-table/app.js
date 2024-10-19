Vue.createApp({
  data() {
    return {
      servers: [
        {
          id: '0',
          hostname: 'db-01',
          ip: '10.10.4.1',
          os: 'Ubuntu 22',
          uptime: '23:32:59',
          status: 'up'
        },
        {
          id: '1',
          hostname: 'db-02',
          ip: '10.10.4.2',
          os: 'Ubuntu 22',
          uptime: '23:32:59',
          status: 'up'
        },
        {
          id: '2',
          hostname: 'db-03',
          ip: '10.10.4.3',
          os: 'Ubuntu 22',
          uptime: '23:32:59',
          status: 'up'
        },
        {
          id: '3',
          hostname: 'db-04',
          ip: '10.10.4.4',
          os: 'Ubuntu 22',
          uptime: '23:32:59',
          status: 'down'
        },
        {
          id: '4',
          hostname: 'server-01',
          ip: '10.10.4.5',
          os: 'Ubuntu 20',
          uptime: '23:32:59',
          status: 'up'
        },
      ]
    }
  },
  methods: {
    numberOfServers() {
      return this.servers.length;
    }
}

  }).mount('#app');

