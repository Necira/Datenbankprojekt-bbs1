<template>
    <div>
        <h1 v-if="typeof winner === 'object'">
            the winner is {{ winner.teamname }} and has gained {{ eloPoints }} elo-points
        </h1>
        <h1 v-else>the winner is {{ winner }} and has gained {{ eloPoints }} elo-points</h1>
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
/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    h1 {
        font-size: 20px;
    }
}
</style>
