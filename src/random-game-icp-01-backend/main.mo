import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Blob "mo:base/Blob";

actor {
  let SubnetManager : actor {
    raw_rand() : async Blob;
  } = actor "aaaaa-aa"; // The management canister for randomness

  public func guess_number(userGuess: Nat) : async Text {
    if (userGuess < 1 or userGuess > 10) {
      return "Your guess must be between 1 and 10!";
    };

    // Fetch raw random bytes
    let randomBlob = await SubnetManager.raw_rand();

    // Convert Blob to an array of Nat8
    let randomBytes : [Nat8] = Blob.toArray(randomBlob);

    if (Array.size(randomBytes) == 0) {
      return "Failed to generate random number. Please try again.";
    };

    // Generate a random number between 1 and 10
    let randomNat = Nat8.toNat(randomBytes[0]) % 10 + 1;

    if (userGuess == randomNat) {
      return "🎉 Congratulations! You guessed it right! The number was " # Nat.toText(randomNat);
    } else {
      return "❌ Sorry, the correct number was " # Nat.toText(randomNat) # ". Try again!";
    };
  };
};
