<template>
  <navigationBar></navigationBar>
  <div class="buttons">
      <RouterLink to="/TeamSettings" class="button"> Team </RouterLink>
      <RouterLink to="/PlayerSettings" class="button"> Player </RouterLink>
      <RouterLink to="/" class="button"> Back </RouterLink>
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

/* Container für die Buttons */
.buttons {
    display: flex;
    flex-direction: column;
    gap: 15px;
    text-align: center;
}

/* Allgemeine Button-Stile */
.button {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: #2d2d2d;
    color: #fff;
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    text-transform: uppercase;
    width: 150px;
    align-self: center;
}

/* Hover-Effekt für Buttons */
.button:hover {
    background-color: var(--green);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

/* Fokus-Effekt für Accessibility */
.button:focus {
    outline: none;
    box-shadow: 0 0 0 2px #ff6f61;
}

/* Responsive Anpassungen */
@media (max-width: 768px) {
    .buttons {
        gap: 10px;
    }
    .button {
        font-size: 14px;
        padding: 12px 20px;
    }
}

</style>
