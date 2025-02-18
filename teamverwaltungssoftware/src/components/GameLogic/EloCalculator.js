export function eloCalculator(winner, loser) {
  const K = 32;

  function expectedScore(player, opponent) {
      return 1 / (1 + Math.pow(10, (opponent - player) / 400));
  }

  const expectedWinner = expectedScore(winner, loser);
  const expectedLoser = expectedScore(loser, winner);

  const newWinner = winner + K * (1 - expectedWinner);
  const newLoser = loser + K * (0 - expectedLoser);
  console.log(newWinner, newLoser ,"winner and loser", winner, loser, "before match")
  return {
      winner: Math.round(newWinner),
      loser: Math.round(newLoser)
  };
}