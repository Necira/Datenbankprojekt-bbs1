<template>
    <div class="buttons">
        <RouterLink to="/OneVsOne"> Player vs Player </RouterLink>
        <RouterLink to="/TeamVsTeam"> Team vs Team</RouterLink>
        <RouterLink to="/TeamTournament">Tournament</RouterLink>
        <RouterLink to="/SettingScreen">Settings</RouterLink>
    </div>
</template>

<script>
export default {
    name: 'HomeScreen',
};
</script>

<style scoped>
.buttons {
    display: flex;
    justify-content: center;
    flex-direction: column;
}

</style>
