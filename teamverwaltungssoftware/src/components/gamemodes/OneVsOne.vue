<template>
    <navigationBar></navigationBar>
    <div class="one-vs-one">
        <div class="player-picks">
            <PlayerPicks
                :player="'Player One'"
                :availablePlayers="availablePlayers"
                @update:playerName="setPlayer('playerOne', $event)"
            />
            <PlayerPicks
                :player="'Player Two'"
                :availablePlayers="availablePlayers"
                @update:playerName="setPlayer('playerTwo', $event)"
            />
        </div>
        <div class="message">
            {{ message }}
        </div>
        <div class="actions" v-if="!winner && playerOne && playerTwo && playerOne != playerTwo">
            <button class="play-randomly" @click="setRandomizedWinner">🎲 Play Randomly</button>
            <div class="choose-winner">
                <label for="chooseWinner">Choose Winner</label>
                <select v-model="chooseWinner" id="chooseWinner" class="dropdown">
                    <option :value="playerOne" v-if="playerOne">{{ playerOne }}</option>
                    <option :value="playerTwo" v-if="playerTwo">{{ playerTwo }}</option>
                </select>
                <button class="set-winner" @click="setWinner(chooseWinner)">🏆 Set Winner</button>
            </div>
        </div>
        <WinnerMessage v-if="winner" :winner="winner" :eloPoints="eloPoints" />
        <RouterLink to="/" class="homescreen-routerlink">← Back to Home</RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import { randomizer } from '../GameLogic/Randomizer.js';
import PlayerPicks from '../Atoms/PlayerPicks.vue';
import WinnerMessage from '../Atoms/WinnerMessage.vue';
import { eloCalculator } from '../GameLogic/EloCalculator.js';
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components: {
        PlayerPicks,
        WinnerMessage,
        navigationBar,
        footerBar,
    },
    name: 'OneVsOne',
    data() {
        return {
            playerOne: '',
            playerTwo: '',
            availablePlayers: [],
            winner: '',
            chooseWinner: '',
            eloPoints: null,
            message: '',
        };
    },
    created() {
        this.fetchPlayers();
    },
    methods: {
        async fetchPlayers() {
            try {
                const response = await fetch('http://localhost:3000/getActivePlayer');
                const data = await response.json();
                this.availablePlayers = data;
            } catch (error) {
                console.error('Error fetching players:', error.message);
            }
        },
        setPlayer(playerName, selectedPlayer) {
            if (playerName === 'playerOne') {
                this.playerOne = selectedPlayer;
            } else if (playerName === 'playerTwo') {
                this.playerTwo = selectedPlayer;
            }
            if (this.playerOne === this.playerTwo) {
                this.message = 'nice try.. select 2 different players ;)';
            } else {
                this.message = '';
            }
        },
        async updateEloPoints(winner, loser) {
            try {
                const responseWinner = await fetch(`http://localhost:3000/getElo/${winner}`);
                const responseLoser = await fetch(`http://localhost:3000/getElo/${loser}`);

                if (!responseWinner.ok || !responseLoser.ok) {
                    throw new Error('Failed to fetch Elo points');
                }
                const dataWinner = await responseWinner.json();
                const dataLoser = await responseLoser.json();
                const currentEloWinner = dataWinner.eloPoints;
                const currentEloLoser = dataLoser.eloPoints;
                const { winner: newEloWinner, loser: newEloLoser } = eloCalculator(
                    currentEloWinner,
                    currentEloLoser,
                );

                await fetch('http://localhost:3000/updatePlayerElo', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        gamewinner: winner,
                        gameloser: loser,
                        eloPointsWinner: newEloWinner,
                        eloPointsLoser: newEloLoser,
                    }),
                });

                return { newEloWinner, newEloLoser };
            } catch (error) {
                console.error('Error updating Elo points:', error.message);
                throw new Error('Failed to update Elo points');
            }
        },
        async setWinner(winner) {
            if (this.playerOne !== this.playerTwo && this.playerOne && this.playerTwo) {
                const loser = winner === this.playerOne ? this.playerTwo : this.playerOne;

                try {
                    const { newEloWinner, newEloLoser } = await this.updateEloPoints(winner, loser);
                    this.message = `Game finished! Winner: ${winner} (${newEloWinner}), Loser: ${loser} (${newEloLoser})`;
                    this.winner = winner;
                } catch (error) {
                    this.message = 'Failed to update Elo points';
                }
            } else {
                this.message = 'Choose two different players without duplicates.';
            }
        },
        async setRandomizedWinner() {
            if (this.playerOne && this.playerTwo && this.playerOne !== this.playerTwo) {
                const { winner, loser } = randomizer(this.playerOne, this.playerTwo);
                this.winner = winner;

                try {
                    const { newEloWinner, newEloLoser } = await this.updateEloPoints(winner, loser);
                    this.eloPoints = 'placeholder';
                    console.log(
                        `Game finished! Winner: ${winner} (${newEloWinner}), Loser: ${loser} (${newEloLoser})`,
                    );
                } catch (error) {
                    console.error('Error updating Elo points:', error.message);
                }
            } else {
                this.message = 'Please select both players and ensure they are different.';
            }
        },
    },
};
</script>

<style scoped>
.one-vs-one {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 30px;
    gap: 20px;
    background-color: var(--white);
    border-radius: 12px;
    box-shadow: 0 4px 8px var(--transparentblack);
    max-width: 600px;
    margin: 50px auto;
}

.player-picks {
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
}

.actions {
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
}

.play-randomly {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: var(--darkgrey);
    color: var(--white);   
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
}

.play-randomly:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

.choose-winner {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.choose-winner label {
    font-size: 16px;
    font-weight: bold;
    color: var(--black);
}

.dropdown {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    color: var(--black);
}

.set-winner {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: var(--darkgrey);
    color: var(--white);   
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
}
.set-winner:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

.homescreen-routerlink {
    font-size: 16px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.homescreen-routerlink:hover {
    color: var(--hoverblue);
    transform: scale(1.05);
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    .dropdown {
        padding: 5px;
        font-size: 14px;
    }

    .choose-winner label {
        font-size: 15px;
    }

    .play-randomly {
        padding: 10px 15px;
        font-size: 13px;
    }

    .set-winner {
        padding: 10px 10px;
        font-size: 13px;
    }
}
</style>
