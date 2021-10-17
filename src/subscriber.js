const createSubscriber = require("pg-listen");

const connectionString =
  "postgresql://<YOURUSER>:12345@localhost:5432/<YOURDB>";

// Accepts the same connection config object that the "pg" package would take
const subscriber = createSubscriber({ connectionString });

subscriber.notifications.on("tweet.activity", (payload) => {
  // Payload as passed to subscriber.notify() (see below)
  console.log("Received notification in 'my-channel':", payload);
});

subscriber.events.on("error", (error) => {
  console.error("Fatal database connection error:", error);
  process.exit(1);
});

process.on("exit", () => {
  subscriber.close();
});

async function connect() {
  await subscriber.connect();
  await subscriber.listenTo("tweet.activity");
}

async function sendSampleMessage() {
  await subscriber.notify("tweet.activity", {
    greeting: "Hey, buddy.",
    timestamp: Date.now(),
  });
}
module.exports = {
  connect,
  sendSampleMessage,
};
