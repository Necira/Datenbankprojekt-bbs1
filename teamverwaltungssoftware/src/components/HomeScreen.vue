<template>
    <div class="buttons">
        <RouterLink to="/OneVsOne"> 1v1 </RouterLink>
        <RouterLink to="/TeamVsTeam"> Team vs Team</RouterLink>
        <RouterLink to="/TournamentMode">Tournament</RouterLink>
        <RouterLink to="/SettingScreen">Settings</RouterLink>
    </div>
</template>

<script>
export default {
    name: 'HomeScreen',
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
