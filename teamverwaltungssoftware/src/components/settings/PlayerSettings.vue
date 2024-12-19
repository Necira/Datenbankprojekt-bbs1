<template>
  <div class="buttons">
      <RouterLink to="/CreateTeam"> Create Player </RouterLink>
      <RouterLink to="/EditTeam"> Edit Player </RouterLink>
      <RouterLink to="/SettingScreen"> Back </RouterLink>
  </div>
</template>

<script>
export default {
  name: 'PlayerSettings',
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
