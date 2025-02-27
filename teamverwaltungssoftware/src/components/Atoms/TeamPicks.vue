<template>
    <div class="team-pick">
        <label :for="team">Choose {{ team }}</label>
        <select v-model="selectedTeam" :id="team">
            <option v-for="team in availableTeams" :key="team.teamID" :value="team.teamname">
                {{ team.teamname }}
            </option>
        </select>
    </div>
</template>

<script>
export default {
    name: 'TeamPicks',
    props: {
        team: String,
        availableTeams: Array,
    },
    data() {
        return {
            selectedTeam: '',
        };
    },
    watch: {
        selectedTeam(newTeam) {
            this.$emit('update:teamName', newTeam);
        },
    },
};
</script>

<style scoped>
.team-pick {
    margin: 15px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

label {
    margin-bottom: 8px;
    font-size: 16px;
    color: var(--black);
    font-weight: 500;
}

select {
    width: 100%;
    max-width: 300px;
    padding: 10px;
    font-size: 16px;
    color: var(--black);
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

select:hover {
    border-color: var(--black);
}

select:focus {
    outline: none;
    border-color: var(--blue);
    box-shadow: 0 0 5px var(--transparentblue);
}

option {
    font-size: 16px;
    padding: 8px;
}

@media (max-width: 768px) {
    select {
        font-size: 14px;
        padding: 8px;
    }
}
</style>
