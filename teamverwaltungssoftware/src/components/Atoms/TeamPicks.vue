<template>
  <div class="team-pick">
      <label :for="team" v-if="availableTeams.length > 0">Choose {{ team }}</label>
      <label v-else>Currently no teams available!</label>
      <select v-model="selected" :id="team">
          <option v-for="teamName in availableTeams" :key="teamName" :value="teamName">
              {{ teamName }}
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
      selectedTeam: String,
  },
  data() {
      return {
          selected: this.selectedTeam || '',
      };
  },
  watch: {
      selected(newTeam) {
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
</style>
