<template>
  <navigationBar></navigationBar>
  <div class="buttons">
      <RouterLink to="/CreatePlayer"> Create Player </RouterLink>
      <RouterLink to="/EditPlayer"> Edit Player </RouterLink>
      <RouterLink to="/SettingScreen"> Back </RouterLink>
  </div>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';

export default {
  components:{
    navigationBar,
  },
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
