<template>
  <div class="First Round">
    <button> Team 1 </button>
    <button> Team 2 </button>
    <button> Team 3 </button>
    <button> Team 4 </button>
    <button> Team 5 </button>
    <button> Team 6 </button>
  </div>
<div class="First Round">
  <button> Team 7 </button>
  <button> Team 8 </button>
  <button> Team 9 </button>
  <button> Team 10 </button>
</div>
<div class="First Round">
  <button> Team 11 </button>
  <button> Team 12 </button>
</div>
<RouterLink to="/"> Back </RouterLink>
</template>

<script>
export default {
name: 'TournamentMode',
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