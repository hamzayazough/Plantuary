// filepath: [meteomatics.service.ts](http://_vscodecontentref_/1)
import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import axios from 'axios';
import * as dotenv from 'dotenv';
import { Address } from 'src/interfaces/address.interface';
import { Weather } from 'src/interfaces/weather.interface';

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

    async getWeatherVariation(days: number, address: Address): Promise<Weather[]> {
        try {
            const token = await this.getToken();
            const now = new Date().toISOString();
            const futureDate = new Date();
    
            const url = `https://api.meteomatics.com/${now}P${days}D:PT24H/t_2m:C,precip_24h:mm,relative_humidity_2m:p/${address.latitude},${address.longitude}/json?access_token=${token}`;
            console.log(url);
            const response = await axios.get(url);
    
            const data = response.data.data;
            const dates = data[0].coordinates[0].dates.map((dateObj: any) => dateObj.date);
    
            const transformedData = dates.map((date: string, index: number) => {
                return {
                    date: date,
                    temperatureC: data[0].coordinates[0].dates[index].value,
                    precipitationMM: data[1].coordinates[0].dates[index].value,
                    relativeHumidity: data[2].coordinates[0].dates[index].value,
                };
            });
    
            return transformedData;
        } catch (error) {
            throw new HttpException("Error fetching weather variation", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}