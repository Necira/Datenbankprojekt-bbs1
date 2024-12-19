<template>
  <div class="buttons">
    <button> Player One </button>
    <button> Player Two </button>
    <button> Play </button>
</div>
<RouterLink to="/"> Back </RouterLink>
</template>

<script>
export default {
name: 'TeamVsTeam',
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