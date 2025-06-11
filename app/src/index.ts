import { createServer } from "./server";

const Port = 3001;

const app = createServer();
app.listen(Port, () => {
    console.log(`Server is running on http://localhost:${Port}`);
});