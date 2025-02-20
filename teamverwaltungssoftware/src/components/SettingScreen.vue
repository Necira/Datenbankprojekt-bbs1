<template>
  <navigationBar></navigationBar>
  <div class="buttons">
      <RouterLink to="/TeamSettings"> Team </RouterLink>
      <RouterLink to="/PlayerSettings"> Player </RouterLink>
      <RouterLink to="/"> Back </RouterLink>
  </div>
</template>

<script>
import navigationBar from './Atoms/navigationBar.vue';

export default {
  components:{
    navigationBar,
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
