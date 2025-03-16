<template>
    <navigationBar></navigationBar>
    <div class="team-vs-team">
        <div class="buttons">
            <TeamPicks
                :team="teamOne"
                :availableTeams="availableTeams"
                @update:teamName="setTeam('teamOne', $event)"
            />
            <TeamPicks
                :team="teamTwo"
                :availableTeams="availableTeams"
                @update:teamName="setTeam('teamTwo', $event)"
            />
        </div>
        <div>
            {{ message }}
        </div>
        <div class="actions" v-if="!winner && teamOne && teamTwo && teamTwo != teamOne">
            <button class="play-randomly" @click="setRandomWinner">🎲 Play Randomly</button>
            <div class="choose-winner">
                <label for="chooseWinner">Choose Winner</label>
                <select v-model="chooseWinner" id="chooseWinner" class="dropdown">
                    <option :value="teamOne">{{ teamOne }}</option>
                    <option :value="teamTwo">{{ teamTwo }}</option>
                </select>
                <button class="set-winner" @click="setWinner(chooseWinner)">🏆 Set Winner</button>
            </div>
        </div>
        <WinnerMessage v-if="winner" :winner="winner" :eloPoints="eloPoints" />
        <RouterLink to="/" class="homescreen-routerlink">← Back</RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import { randomizer } from '../GameLogic/Randomizer.js';
import TeamPicks from '../Atoms/TeamPicks.vue';
import WinnerMessage from '../Atoms/WinnerMessage.vue';
import { eloCalculator } from '../GameLogic/EloCalculator.js';
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components: {
        TeamPicks,
        WinnerMessage,
        navigationBar,
        footerBar,
    },
    name: 'TeamVsTeam',
    data() {
        return {
            teamOne: '',
            teamTwo: '',
            availableTeams: [],
            winner: '',
            message: '',
        };
    },
    created() {
        this.fetchTeams();
    },
    methods: {
        async fetchTeams() {
            try {
                const response = await fetch('http://localhost:3000/getActiveAndCompleteTeams');
                const data = await response.json();
                this.availableTeams = data;
            } catch (error) {
                console.error('Error fetching teams:', error.message);
            }
        },
        setTeam(teamName, selectedTeam) {
            if (teamName === 'teamOne') {
                this.teamOne = selectedTeam;
            } else if (teamName === 'teamTwo') {
                this.teamTwo = selectedTeam;
            }
            if (this.teamOne === this.teamTwo) {
                this.message = 'nice try.. select 2 different teams ;)';
            } else {
                this.message = '';
            }
        },
        async updateTeamEloPoints(winningTeam, losingTeam) {
            try {
                const responseWinner = await fetch(`http://localhost:3000/getTeamElo/${winningTeam}`);
                const responseLoser = await fetch(`http://localhost:3000/getTeamElo/${losingTeam}`);
                if (!responseWinner.ok || !responseLoser.ok) {
                    throw new Error('Failed to fetch Elo points for teams');
                }
                const dataWinner = await responseWinner.json();
                const dataLoser = await responseLoser.json();
                const currentEloWinner = dataWinner.eloPoints;
                const currentEloLoser = dataLoser.eloPoints;
                const { winner: newEloWinner, loser: newEloLoser } = eloCalculator(
                    currentEloWinner,
                    currentEloLoser,
                );

                await fetch('http://localhost:3000/updateTeamElo', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        gamewinner: winningTeam,
                        gameloser: losingTeam,
                        eloPointsWinner: newEloWinner,
                        eloPointsLoser: newEloLoser,
                    }),
                });

                this.recalculatePlayerEloPoints(
                    currentEloLoser,
                    newEloLoser,
                    currentEloWinner,
                    newEloWinner,
                    winningTeam,
                    losingTeam,
                );
                return { newEloWinner, newEloLoser };
            } catch (error) {
                console.error('Error updating team Elo points:', error.message);
                throw new Error('Failed to update team Elo points');
            }
        },
        async setWinner(winner) {
            if (this.teamOne && this.teamTwo && this.teamOne !== this.teamTwo) {
                let loser = '';
                if (winner) {
                    loser = winner === this.teamOne ? this.teamTwo : this.teamOne;
                    try {
                        const { newEloWinner, newEloLoser } = await this.updateTeamEloPoints(winner, loser);
                        console.log(
                            `Game finished! Winner: ${winner} (${newEloWinner}), Loser: ${loser} (${newEloLoser})`,
                        );
                    } catch (error) {
                        console.error('Error updating Elo points:', error.message);
                    }
                    this.winner = winner;
                } else {
                    this.message = 'Nice try... choose a winner!';
                }
            } else {
                this.message = 'Choose two different teams.';
            }
        },
        async setRandomWinner() {
            if (this.teamOne && this.teamTwo && this.teamOne !== this.teamTwo) {
                const { winner, loser } = randomizer(this.teamOne, this.teamTwo);
                this.winner = winner;

                try {
                    const { newEloWinner, newEloLoser } = await this.updateTeamEloPoints(winner, loser);
                    console.log(
                        `Game finished! Winner: ${winner} (${newEloWinner}), Loser: ${loser} (${newEloLoser})`,
                    );
                } catch (error) {
                    console.error('Error updating Elo points:', error.message);
                }
            } else {
                this.message = 'Please select both teams and ensure they are different.';
            }
        },
        recalculatePlayerEloPoints(
            oldEloPointsLoser,
            newEloPointsLoser,
            oldEloPointsWinner,
            newEloPointsWinner,
            winner,
            loser,
        ) {
            let differenceEloPointsWinner = Math.round((newEloPointsWinner - oldEloPointsWinner) / 5);
            let differenceEloPointsLoser = Math.round((newEloPointsLoser - oldEloPointsLoser) / 5);

            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        let teammember = [
                            data[i].firstMember,
                            data[i].secondMember,
                            data[i].thirdMember,
                            data[i].fourthMember,
                            data[i].fifthMember,
                        ];
                        if (data[i].teamname === winner) {
                            for (let a = 0; a < teammember.length; a++) {
                                fetch('http://localhost:3000/updateTeammemberEloWinner', {
                                    method: 'PATCH',
                                    headers: {
                                        'Access-Control-Allow-Origin': '*',
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({
                                        currentPlayer: teammember[a],
                                        eloPointsDifferenceWinner: differenceEloPointsWinner,
                                    }),
                                })
                                    .then(response => response.json())
                                    .catch(error => {
                                        console.error(error);
                                        return;
                                    });
                            }
                        } else if (data[i].teamname === loser) {
                            for (let a = 0; a < teammember.length; a++) {
                                fetch('http://localhost:3000/updateTeammemberEloLoser', {
                                    method: 'PATCH',
                                    headers: {
                                        'Access-Control-Allow-Origin': '*',
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({
                                        currentPlayer: teammember[a],
                                        eloPointsDifferenceLoser: differenceEloPointsLoser,
                                    }),
                                })
                                    .then(response => response.json())
                                    .catch(error => {
                                        console.error(error);
                                        return;
                                    });
                            }
                        }
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
    },
};
</script>

<style scoped>
.team-vs-team {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 30px;
    background-color: var(--white);
    border-radius: 12px;
    box-shadow: 0 4px 8px var(--transparentblack);
    max-width: 600px;
    margin: 50px auto;
}

.buttons {
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
    max-width: 400px;
}

.actions {
    display: flex;
    flex-direction: column;
    gap: 20px;
    width: 100%;
    max-width: 400px;
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
    border: none;
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

.choose-winner label {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 5px;
    color: var(--black);
}

.dropdown {
    padding: 12px;
    font-size: 16px;
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    width: 100%;
}

.set-winner {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: var(--darkgrey);
    color: var(--white);
    font-size: 16px;
    border: none;
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
    margin-top: 20px;
    font-size: 16px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
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
