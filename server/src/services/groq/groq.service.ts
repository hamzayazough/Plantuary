import { Injectable } from '@nestjs/common';
import { HttpException, HttpStatus } from '@nestjs/common';
import Groq from "groq-sdk";
import * as dotenv from 'dotenv';

dotenv.config();
@Injectable()
export class GroqService {
    private readonly groq = new Groq({ apiKey: process.env.GROQ_API });

    async getGroqChatCompletion(): Promise<Groq.Chat.Completions.ChatCompletion> {
        try {
            console.log("chat completion:");
            return this.groq.chat.completions.create({
            messages: [
                {
                role: "user",
                content: "Explain the importance of fast language models",
                },
            ],
            model: "llama-3.3-70b-versatile",
            });
        } catch (error) {
            console.error("Error getting GROQ chat completion", error);
            throw new HttpException("Error fetching Groq chat completion", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
