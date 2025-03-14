<template>
    <navigationBar></navigationBar>
    <div class="tournament">
        <h2>Tournament</h2>
        <TournamentRound
            v-if="currentRound === 0"
            :roundIndex="0"
            :matches="rounds[0]"
            :availableTeams="availableTeams"
            :isFirstRound="true"
            :isCurrentRound="currentRound === 0"
            @setWinners="handleWinners"
        />
        <TournamentRound
            v-if="currentRound === 1"
            :roundIndex="1"
            :matches="rounds[1]"
            :availableTeams="winners[0]"
            :isFirstRound="false"
            :isCurrentRound="currentRound === 1"
            @setWinners="handleWinners"
        />
        <TournamentRound
            v-if="currentRound === 2"
            :roundIndex="2"
            :matches="rounds[2]"
            :availableTeams="winners[1]"
            :isFirstRound="false"
            :isCurrentRound="currentRound === 2"
            @setWinners="handleWinners"
        />
        <div v-if="finalWinner" class="champion">
            <h3>Champion: {{ finalWinner }}</h3>
        </div>
        <RouterLink to="/" class="homescreen-routerlink">← Back</RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import TournamentRound from '../Atoms/TournamentRound.vue';
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    name: 'TeamTournament',
    components: {
        TournamentRound,
        navigationBar,
        footerBar,
    },
    data() {
        return {
            availableTeams: [],
            rounds: [[], [], []],
            winners: [[], []],
            currentRound: 0,
            finalWinner: null,
        };
    },
    async created() {
        await this.fetchTeams();
        this.setupFirstRound();
    },
    methods: {
        async fetchTeams() {
            try {
                const response = await fetch('http://localhost:3000/getActiveteams');
                const data = await response.json();
                this.availableTeams = data.map(team => team.teamname);
            } catch (error) {
                console.error('Error fetching teams:', error.message);
            }
        },
        setupFirstRound() {
            const firstRound = [];
            for (let i = 0; i < 8; i += 2) { 
                firstRound.push({
                    teamOne: this.availableTeams[i] || '',
                    teamTwo: this.availableTeams[i + 1] || '',
                    winner: '',
                });
            }
            this.rounds[0] = firstRound;
        },
        handleWinners(winners, roundIndex) {
            winners.forEach((winner, matchIndex) => {
                this.rounds[roundIndex][matchIndex].winner = winner;
            });
            this.advanceToNextRound(roundIndex);
        },
        advanceToNextRound(roundIndex) {
            const winners = this.rounds[roundIndex].map(match => match.winner);
            if (winners.length === 1) {
                this.finalWinner = winners[0];
                return;
            }
            this.winners[roundIndex] = winners;
            const nextRound = [];
            for (let i = 0; i < winners.length; i += 2) {
                nextRound.push({ teamOne: winners[i], teamTwo: winners[i + 1] || '', winner: '' });
            }
            this.rounds[roundIndex + 1] = nextRound;
            this.currentRound++;
        },
    },
};
</script>

<style scoped>
.tournament {
    padding: 20px;
    background-color: var(--white);
    border-radius: 12px;
    max-width: 800px;
    margin: 50px auto;
    text-align: center;
}
.champion {
    font-size: 18px;
    font-weight: bold;
    color: var(--hovergreen);
    margin-top: 20px;
}
.homescreen-routerlink {
    display: inline-block;
    margin-top: 20px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
}
.homescreen-routerlink:hover {
    color: var(--hoverblue);
}
</style>