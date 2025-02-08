// filepath: [meteomatics.service.ts](http://_vscodecontentref_/1)
import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import axios from 'axios';
import * as dotenv from 'dotenv';

dotenv.config();

@Injectable()
export class MeteomaticsService {
    private readonly username = process.env.METEOMATICS_USERNAME;
    private readonly password = process.env.METEOMATICS_PASSWORD;
    private token: string = "";
    private tokenExpiration: number | null = null;

    async getToken(): Promise<string> {
        if (this.token && this.tokenExpiration && Date.now() < this.tokenExpiration) {
            return this.token;
        }

        try {
            console.log("Fetching Meteomatics token");
            const authHeader = "Basic " + Buffer.from(`${this.username}:${this.password}`).toString('base64');

            const response = await axios.get("https://login.meteomatics.com/api/v1/token", {
                headers: { Authorization: authHeader },
            });

            this.token = response.data.access_token;
            this.tokenExpiration = Date.now() + (response.data.expires_in * 1000);

            return this.token;
        } catch (error) {
            throw new HttpException("Error fetching Meteomatics token", HttpStatus.UNAUTHORIZED);
        }
    }
}