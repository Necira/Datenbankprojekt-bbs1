<template>
    <h1>test</h1>
    <div class="buttons">
        <input v-model="Teamname" placeholder="Teamname" />
    </div>
    <RouterLink to="/TeamSettings"> Back </RouterLink>
</template>

<script>
export default {
    name: 'CreateTeam',
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.buttons {
    display: flex;
    justify-content: center;
    flex-direction: column;
}
</style>
