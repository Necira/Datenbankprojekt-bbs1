<template>
    <setting-screen></setting-screen>
    <HomeScreen></HomeScreen>
    <router-view></router-view>
</template>

<script></script>

<style>
#app {
    font-family: 'Montserrat', sans-serif;
    font-optical-sizing: auto;
    font-weight: 400;
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: var(--black);
    margin-top: 60px;
}

:root {
    --black: #000000;
    --transparentblack: #00000024;
    --lightred: #ff6f61;
    --red: #ff0000;
    --white: #ffffff;
    --lightgrey: #888;
    --lightgrey2: #d2d2d2;
    --darkgrey: #2d2d2d;
    --hovergreen: #41b883;
    --lightgreen: #52e7a4;
    --green: #008000;
    --blue: #007bff;
    --hoverblue: #0056b3;
    --transparentblue: #5d5dff79;
}
</style>
