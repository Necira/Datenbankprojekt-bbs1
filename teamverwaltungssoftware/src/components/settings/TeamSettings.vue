<template>
  <div class="buttons">
      <RouterLink to="/CreateTeam"> Create Team </RouterLink>
      <RouterLink to="/EditTeam"> Edit Team </RouterLink>
      <RouterLink to="/SettingScreen"> Back </RouterLink>
  </div>
</template>

<script>
export default {
  name: 'TeamSettings',
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.buttons {
  display: flex;
  justify-content: center;
  flex-direction: column;
}

</style>
