<template>
  <navigationBar></navigationBar>
  <div class="buttons">
      <RouterLink to="/TeamSettings"> Team </RouterLink>
      <RouterLink to="/PlayerSettings"> Player </RouterLink>
      <RouterLink to="/"> Back </RouterLink>
  </div>
  <footerBar></footerBar>
</template>

<script>
import navigationBar from './Atoms/navigationBar.vue';
import footerBar from './Atoms/footerBar.vue';

export default {
  components:{
    navigationBar,
    footerBar,
  },
  name: 'SettingScreen',
};
</script>

<style scoped>
.buttons {
  display: flex;
  justify-content: center;
  flex-direction: column;
}

</style>
