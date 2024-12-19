<template>
  <div class="buttons">
      <RouterLink to="/TeamSettings"> Team </RouterLink>
      <RouterLink to="/PlayerSettings"> Player </RouterLink>
      <RouterLink to="/"> Back </RouterLink>
  </div>
</template>

<script>
export default {
  name: 'SettingScreen',
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
