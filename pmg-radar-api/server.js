require("dotenv").config();
const express = require("express");
const axios = require("axios");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

let accessToken = null;
let tokenExpiresAt = 0;

// Function to get a new Spotify token
async function getSpotifyToken() {
  if (accessToken && Date.now() < tokenExpiresAt) {
    return accessToken; // Use cached token if valid
  }

  try {
    const response = await axios.post(
      "https://accounts.spotify.com/api/token",
      new URLSearchParams({
        grant_type: "client_credentials",
        client_id: process.env.SPOTIFY_CLIENT_ID,
        client_secret: process.env.SPOTIFY_CLIENT_SECRET,
      }).toString(),
      { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
    );

    accessToken = response.data.access_token;
    tokenExpiresAt = Date.now() + response.data.expires_in * 1000; // Cache token
    return accessToken;
  } catch (error) {
    console.error("Error fetching Spotify token:", error);
    throw new Error("Failed to get Spotify token");
  }
}

// API route to fetch an artist's top tracks
app.get("/api/top-tracks", async (req, res) => {
  try {
    const token = await getSpotifyToken();
    const artistId = req.query.artistId || "5tQMB0cuNXdCtzovGt55uD"; // Luki artistId

    const response = await axios.get(
      `https://api.spotify.com/v1/artists/${artistId}/top-tracks?market=US`,
      { headers: { Authorization: `Bearer ${token}` } }
    );

    res.json(response.data.tracks.map((track) => ({
      name: track.name,
      popularity: track.popularity,
    })));
  } catch (error) {
    console.error("Error fetching Spotify data:", error);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
