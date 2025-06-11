import { Router, type Response, type Request } from "express";

const router = Router();

const users = [
    { id: 1, name: "John Doe" },
    { id: 2, name: "Jane Smith" },
    { id: 3, name: "Alice Johnson" },
    { id: 4, name: "Bob Brown" },
    { id: 5, name: "Charlie White" }
]

router.get("/all", (req: Request, res: Response) => {
    res.status(200).json(users);
});

router.get("/id/:id", (req: Request, res: Response) => {
    const userId = parseInt(req.params.id ?? "", 10);
    const user = users.find(u => u.id === userId);
    
    if (user) {
        res.status(200).json(user);
    } else {
        res.status(404).json({ message: "User not found" });
    }
});

router.get("/slow", (req: Request, res: Response) => {
    setTimeout(() => {
        res.status(200).json(users);
    }, 3000)
});

export const userRouter: Router = router;