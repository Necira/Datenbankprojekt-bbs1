import { createApp } from 'vue';
import App from './App.vue';

import { createRouter, createWebHistory } from 'vue-router';
import HomeScreen from './components/HomeScreen.vue';

const router = createRouter({
    routes: [{ path: '/', component: HomeScreen }],
    history: createWebHistory(),
});

createApp(App).use(router).mount('#app');
