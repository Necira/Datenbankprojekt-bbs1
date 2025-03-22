export function randomizer(playerOne, playerTwo) {
  let result = Math.floor(Math.random() * 2);
  if (result > 0) {
    return { winner: playerOne, loser: playerTwo };
  } else {
    return { winner: playerTwo, loser: playerOne };
  }
}