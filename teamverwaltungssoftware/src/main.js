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

/** create router instance: https://router.vuejs.org/guide/
 *  routes-property defines the path itself and the components,
 *  that will be displayed on it.
 */
const router = createRouter({
    routes: [
        { path: '/', component: HomeScreen }, 
        { path: '/SettingScreen', component: SettingScreen},
        { path: '/TeamSettings', component: TeamSettings},
        { path: '/PlayerSettings', component: PlayerSettings},
        { path: '/CreateTeam', component: CreateTeam},
        { path: '/EditTeam', component: EditTeam},
        { path: '/CreatePlayer', component: CreatePlayer},
    ],
    // mapps the routes to the the URL
    history: createWebHistory(),
});

createApp(App).use(router).mount('#app');
