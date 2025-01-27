import { createApp } from 'vue';
import App from './App.vue';
import { createRouter, createWebHistory } from 'vue-router';
import HomeScreen from './components/HomeScreen.vue';
import SettingScreen from './components/SettingScreen.vue';
import TeamSettings from './components/settings/TeamSettings.vue';
import PlayerSettings from './components/settings/PlayerSettings.vue';
import CreatePlayer from './components/settings/CreatePlayer.vue';
import CreateTeam from './components/settings/CreateTeam.vue';
import EditTeam from './components/settings/EditTeam.vue';
import OneVsOne from './components/gamemodes/OneVsOne.vue';
import TeamVsTeam from './components/gamemodes/TeamVsTeam.vue';
import TeamTournament from './components/gamemodes/TeamTournament.vue';
import EditPlayer from './components/settings/EditPlayer.vue';

const router = createRouter({
    routes: [
        { path: '/', component: HomeScreen },
        { path: '/SettingScreen', component: SettingScreen },
        { path: '/TeamTournament', component: TeamTournament },
        { path: '/TeamSettings', component: TeamSettings },
        { path: '/PlayerSettings', component: PlayerSettings },
        { path: '/CreateTeam', component: CreateTeam },
        { path: '/EditTeam', component: EditTeam },
        { path: '/EditPlayer', component: EditPlayer },
        { path: '/CreatePlayer', component: CreatePlayer },
        { path: '/OneVsOne', component: OneVsOne },
        { path: '/TeamVsTeam', component: TeamVsTeam },
       
    ],
    history: createWebHistory(),
});

createApp(App).use(router).mount('#app');
