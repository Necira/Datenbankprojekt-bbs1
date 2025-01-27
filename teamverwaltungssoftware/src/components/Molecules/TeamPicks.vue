<template>
  <div class="teamPick">
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
    }
  },
  watch: {
    selectedTeam(newTeam) {
      this.$emit('update:teamName', newTeam);  
    }
  }
};
</script>

<style scoped>
.teamPick {
  margin: 10px;
}

select {
  padding: 5px;
}
</style>
