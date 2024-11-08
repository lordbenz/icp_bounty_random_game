import Nat "mo:base/Nat";
import Random "mo:base/Random";
import ManagementCanister "ic:aaaaa-aa";

actor {
  
  public func guess_number(userGuess: Nat) : async Text {
    if (userGuess < 1 or userGuess > 10) {
      return "Your guess must be between 1 and 10!";
    };

    // Fetch raw random bytes
    let randomBlob = await ManagementCanister.raw_rand();

    let finite = Random.Finite(randomBlob);

    // Convert Blob to an array of Nat8
    // let randomBytes : [Nat8] = Blob.toArray(randomBlob);

    // if (Array.size(randomBytes) == 0) {
    //   return "Failed to generate random number. Please try again.";
    // };

    // Generate a random number between 1 and 10
    // let randomNumber = Nat8.toNat(randomBytes[0]) % 10 + 1;
    let maybeNullrandomNumber = finite.range(4);

    switch(maybeNullrandomNumber) {
      case null return "Failed to generate random number. Please try again.";
      case (?randomNumber) {
        if (userGuess == randomNumber) {
      return "🎉 Congratulations! You guessed it right! The number was " # Nat.toText(randomNumber);
    } else {
      return "❌ Sorry, the correct number was " # Nat.toText(randomNumber) # ". Try again!";
    };
      }
    };

    
  };
};
