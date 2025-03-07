<template>
    <navigationBar></navigationBar>
    <div class="buttons">
        <RouterLink to="/CreatePlayer" class="button"> Create Player </RouterLink>
        <RouterLink to="/EditPlayer" class="button"> Edit Player </RouterLink>
        <RouterLink to="/SettingScreen" class="button"> Back </RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components: {
        navigationBar,
        footerBar,
    },
    name: 'PlayerSettings',
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
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
    background-color: var(--darkgrey);
    color: var(--white);
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
    width: 150px;
    align-self: center;
}

/* Hover-Effekt für Buttons */
.button:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

/* Fokus-Effekt für Accessibility */
.button:focus {
    outline: none;
    box-shadow: 0 0 0 2px var(--lightred);
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    .button {
        font-size: 13px;
        padding: 10px 15px;
    }
}
</style>
