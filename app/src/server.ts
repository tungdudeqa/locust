import express, { type Application } from 'express';
import { userRouter } from './routes/userRouter.js';

export const createServer  = (): Application => {
    const app = express();
    
    app.use(express.json());
    app.use("/user", userRouter);

    return app;
}