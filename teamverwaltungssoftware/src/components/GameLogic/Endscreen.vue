<OneVsOne @game="startGameHandler" />
<RouterLink to="/"> Back to Homescreen </RouterLink>
<script>
export default {
  methods: {
    gameResult({ playerOne, playerTwo }) {
      console.log('Game starting with:', playerOne, playerTwo);
      // Additional logic for starting the game
    },
  },
};
</script>