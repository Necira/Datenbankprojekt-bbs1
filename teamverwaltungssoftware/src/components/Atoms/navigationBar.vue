<template>
    <header>
        <nav>
            <ul>
                <!--WARNING: Do not remove id of list elements, they are used to indicate the current visited page-->
                <li><RouterLink to="/" id="homeComponent-routerlink">Home</RouterLink></li>
                <!-- <li><RouterLink to="/OneVsOne">1 vs 1</RouterLink></li>
        <li><RouterLink to="/TeamVsTeam">T vs T</RouterLink></li>
        <li><RouterLink to="/TeamTournament">Tournament</RouterLink></li>
        <li><RouterLink to="/SettingScreen">Settings</RouterLink></li> -->
                <li><RouterLink to="/Leaderboards" id="leaderboard-routerlink">Leaderboard</RouterLink></li>
            </ul>
            <h1>Teamverwaltungssoftware</h1>
        </nav>
    </header>
</template>

<style scoped>
h1 {
    font-size: 23px;
    color: var(--white);
    padding-right: 20px;
    margin: 0;
}

ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
}

header {
    position: fixed;
    top: 0;
    width: 100%;
    left: 0;
    right: 0;
    background-color: var(--black);
}

nav {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

li {
    float: left;
    border-right: 2px solid var(--white);
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

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    li a {
        font-size: 14px;
        padding: 3px 3px;
    }

    li {
        width: 90%;
    }

    h1 {
        font-size: 19px;
        padding-right: 5px;
    }
}
</style>
