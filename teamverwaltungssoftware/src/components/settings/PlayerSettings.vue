<template>
  <navigationBar></navigationBar>
  <div class="buttons">
      <RouterLink to="/CreatePlayer"> Create Player </RouterLink>
      <RouterLink to="/EditPlayer"> Edit Player </RouterLink>
      <RouterLink to="/SettingScreen"> Back </RouterLink>
  </div>
  <footerBar></footerBar>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
  components:{
    navigationBar,
    footerBar,
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
