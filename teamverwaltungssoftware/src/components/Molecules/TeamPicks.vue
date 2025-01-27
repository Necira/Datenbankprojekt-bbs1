<template>
  <div class="teamPick">
    <label :for="team">Choose {{ team }}</label>
    <select v-model="selectedTeam" :id="team">
      <option v-for="team in availableTeams" :key="team" :value="team">
        {{ team }}
      </option>
    </select>
  </div>
</template>

<script>
export default {
  name: 'TeamPicks',
  props: {
    team: String, 
    availableTeams: {
      type: Array,
      default: () => []
    }
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
