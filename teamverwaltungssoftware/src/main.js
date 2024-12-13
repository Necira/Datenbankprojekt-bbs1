import { createApp } from 'vue';
import App from './App.vue';
import { createRouter, createWebHistory } from 'vue-router';
import HomeScreen from './components/HomeScreen.vue';

/** create router instance: https://router.vuejs.org/guide/
 *  routes-property defines the path itself and the components,
 *  that will be displayed on it.
 */
const router = createRouter({
    routes: [{ path: '/', component: HomeScreen }],
    // mapps the routes to the the URL
    history: createWebHistory(),
});

createApp(App).use(router).mount('#app');
