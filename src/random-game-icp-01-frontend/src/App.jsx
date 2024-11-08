import { useState, useEffect } from 'react';
import { AuthClient } from "@dfinity/auth-client";
import { random_game_icp_01_backend } from 'declarations/random-game-icp-01-backend';

function App() {
  const [authClient, setAuthClient] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [guess, setGuess] = useState('');
  const [result, setResult] = useState('');

  // Initialize AuthClient
  useEffect(() => {
    const initAuth = async () => {
      const client = await AuthClient.create();
      setAuthClient(client);
      const isAuthed = await client.isAuthenticated();
      setIsAuthenticated(isAuthed);
    };
    initAuth();
  }, []);

  const login = async () => {
    if (!authClient) return;

    await new Promise((resolve, reject) => {
      authClient.login({
        identityProvider: "https://identity.ic0.app",
        onSuccess: () => {
          setIsAuthenticated(true);
          resolve(null);
        },
        onError: reject,
      });
    });
  };

  const logout = async () => {
    if (!authClient) return;
    await authClient.logout();
    setIsAuthenticated(false);
  };

  // Handle guessing game submission
  const handleGuessSubmit = async (event) => {
    event.preventDefault();
    if (!guess || isNaN(guess) || guess < 1 || guess > 10) {
      setResult('Please enter a valid number between 1 and 10.');
      return;
    }

    const response = await random_game_icp_01_backend.guess_number(Number(guess));
    setResult(response);
  };

  return (
    <main>
      <header>
        <h1>Random Guessing Game with Internet Identity</h1>
        {isAuthenticated ? (
          <button onClick={logout} className="auth-button">Logout</button>
        ) : (
          <button onClick={login} className="auth-button">Login with Internet Identity</button>
        )}
      </header>

      {isAuthenticated ? (
        <div>
          <h2>Guess the Number (1-10)</h2>
          <form onSubmit={handleGuessSubmit}>
            <label htmlFor="guess">Enter your guess: &nbsp;</label>
            <input
              id="guess"
              type="number"
              min="1"
              max="10"
              value={guess}
              onChange={(e) => setGuess(e.target.value)}
              required
            />
            <button type="submit">Submit Guess</button>
          </form>
          <section id="result">{result}</section>
        </div>
      ) : (
        <div className="auth-prompt">
          <p>Please login with Internet Identity to access the game.</p>
        </div>
      )}
    </main>
  );
}

export default App;
