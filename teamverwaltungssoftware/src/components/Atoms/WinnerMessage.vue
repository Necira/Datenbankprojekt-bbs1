<template>
    <div class="message">
        <h1>the winner is {{ winner }} and has gained {{ eloPoints }} elo-points</h1>
    </div>
</template>

<script>
export default {
    name: 'WinnerMessage',
    props: {
        winner: String,
        eloPoints: String,
    },
};
</script>

<style scoped>
.teamPick {
    margin: 10px;
}

select {
    padding: 5px;
}
</style>
