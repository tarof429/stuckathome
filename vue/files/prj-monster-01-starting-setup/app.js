function getRandomValue(min, max) {
    return  Math.floor(Math.random() * (max - min) + min);    
}

const app = Vue.createApp({
        data() {
            return { 
              playerHealth: 100,
              monsterHealth: 100,
              currentRound: 0,
              battleLog: [],
              winner: null
            };
          },
    
        methods: {

            addBattleLog(battleLog) {
                console.log(battleLog);
                this.battleLog.push(battleLog);
              },
          

            // Do an attack. The monster hits us harder.
            attackMonster() {
                //this.addBattleLog('Attack Monster');
                const attackValue = getRandomValue(5, 12);

                if (this.monsterHealth - attackValue < 0) {
                    this.monsterHealth = 0;
                } else {
                    this.monsterHealth -= attackValue;
                }

                this.attackPlayer();

                // this.addBattleLog('Player health: ' + this.playerHealth);
                // this.addBattleLog('Monster health: ' + this.monsterHealth);
                this.currentRound++;
            },

            specialAttack() {
                //this.addBattleLog('Special Attack');
                const attackValue = getRandomValue(10, 20);
                
                // this.monsterHealth -= attackValue;

                if (this.monsterHealth - attackValue < 0) {
                    this.monsterHealth = 0;
                } else {
                    this.monsterHealth -= attackValue;
                }

                this.attackPlayer();
                this.currentRound++;

                // this.ddBattleLog('Player health: ' + this.playerHealth);
                // this.addBattleLog('Monster health: ' + this.monsterHealth);
            },


            attackPlayer() {
                //this.addBattleLog("Attack Player");
                const attackValue = getRandomValue(8, 15);

                // this.playerHealth -= attackValue;

                if (this.playerHealth - attackValue < 0) {
                    this.playerHealth = 0;
                } else {
                    this.playerHealth -= attackValue;
                }
            },

            heal() {
                //this.addBattleLog('Heal');
                const healValue = getRandomValue(10, 20);

                if (this.playerHealth + healValue > 100) {
                    this.playerHealth = 100;
                } else {
                    this.playerHealth += healValue;
                }

                this.attackPlayer();
                this.currentRound++;

                // this.addBattleLog('Player health: ' + this.playerHealth);
                // this.addBattleLog('Monster health: ' + this.monsterHealth);
            },

            surrender() {
                //this.addBattleLog('Surrender');
                //this.playerHealth = 0;
                this.winner = 'monster';
            },

            startNewGame() {
                this.playerHealth = 100;
                this.monsterHealth = 100;
                this.currentRound = 0;
                this.battleLog = [];
                this.winner = null;
            }
        },

        watch: {

            playerHealth(value) {
                if (value <= 0 && this.monsterHealth <= 0) {
                    this.winner = 'draw';
                    this.addBattleLog('Draw');
                    
                } else if (value <= 0) {
                    this.winner = 'monster';
                    this.addBattleLog('Player lost');

                } else {
                    this.addBattleLog('Player health: ' + this.playerHealth);
                }
            },

            monsterHealth(value) {
                if (value <= 0 && this.playerHealth <= 0) {
                    this.winner = 'draw';
                    this.addBattleLog('Draw');
                 } else if (value <= 0) {
                    // monster lost
                    this.addBattleLog('Player won');
                    this.winner = 'player';
                 } else {
                    this.addBattleLog('Monster health: ' + this.monsterHealth);
                 }
            }
        },

        computed: {

            monsterBarStyles() {
                if (this.monsterHealth <= 0) {
                    return {width:  '0%'};
                }
                return {width: this.monsterHealth + '%'};
            },

            playerBarStyles() {
                if (this.playerHealth <= 0) {
                    return {width:  '0%'};
                }
                return {width: this.playerHealth + '%'};
            },

            specialAttackAvailable() {
                return this.currentRound % 3 != 0;
            },

            gameOver() {
                return this.winner != null;
            }
        }
        
});
    
app.mount('#game');
    