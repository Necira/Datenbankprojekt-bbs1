<template>
    <ul>
        <li><RouterLink to="/">Home</RouterLink></li>
        <!-- <li><RouterLink to="/OneVsOne">1 vs 1</RouterLink></li>
        <li><RouterLink to="/TeamVsTeam">T vs T</RouterLink></li>
        <li><RouterLink to="/TeamTournament">Tournament</RouterLink></li>
        <li><RouterLink to="/SettingScreen">Settings</RouterLink></li> -->
        <li><RouterLink to="/Leaderboards">Leaderboards</RouterLink></li>
    </ul>
</template>

<style scoped>
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: var(--black);
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
    color: var(--white);
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

li a:hover {
    background-color: var(--hovergreen);
}

li {
    border-right: 2px solid var(--lightgrey);
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    li a {
        font-size: 14px;
        padding: 5px 5px;
    }
}
</style>
