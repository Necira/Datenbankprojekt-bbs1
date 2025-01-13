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
import TournamentMode from './components/gamemodes/TournamentMode.vue';
import EditPlayer from './components/settings/EditPlayer.vue';
import axios from 'axios';

const router = createRouter({
    routes: [
        { path: '/', component: HomeScreen },
        { path: '/SettingScreen', component: SettingScreen },
        { path: '/TeamSettings', component: TeamSettings },
        { path: '/PlayerSettings', component: PlayerSettings },
        { path: '/CreateTeam', component: CreateTeam },
        { path: '/EditTeam', component: EditTeam },
        { path: '/EditPlayer', component: EditPlayer },
        { path: '/CreatePlayer', component: CreatePlayer },
        { path: '/OneVsOne', component: OneVsOne },
        { path: '/TeamVsTeam', component: TeamVsTeam },
        { path: '/TournamentMode ', component: TournamentMode },
    ],
    history: createWebHistory(),
});

createApp(App).use(router).mount('#app');

axios.get('http://localhost:3000/api/getPlayer')  // Ändere backend zu localhost
    .then(response => {
        console.log('Players:', response.data);
    })
    .catch(error => {
        console.error('Error fetching players:', error);
    });