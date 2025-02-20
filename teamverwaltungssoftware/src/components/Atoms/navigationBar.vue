<template>
    <ul>
        <li><RouterLink to="/"> Home </RouterLink></li>
        <li><RouterLink to="/OneVsOne">Player vs Player</RouterLink></li>
        <li><RouterLink to="/TeamVsTeam">Team vs Team</RouterLink></li>
        <li><RouterLink to="/TeamTournament">Tournament</RouterLink></li>
        <li><RouterLink to="/SettingScreen">Settings</RouterLink></li>
        <li><a href="#about">Leaderboards</a></li>
    </ul>
</template>

<style scoped>
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #000000;
}

ul {
    position: fixed;
    top: 0;
    width: 100%;
    left: 0;
    right: 0;
}

li {
    float: left;
}

li a {
    display: block;
    color: rgb(255, 255, 255);
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

li a:hover {
    background-color: #3f3f3f;
}

li {
    border-right: 2px solid #bbb;
}

</style>