import { Injectable, Logger } from '@nestjs/common';
import { PlantService } from './../plant/plant.service';
import { GroqService } from './../groq/groq.service';
import { MeteomaticsService } from './../meteomatics/meteomatics.service';
import { Address } from 'src/interfaces/address.interface';
import Groq from 'groq-sdk';
import { PlantStat, TestConnectionDto } from 'src/interfaces/report.interface';
import { AnalyzeRequest } from 'src/interfaces/analyze.interface';
import { interval } from 'rxjs';
import { Section } from 'src/interfaces/section.interface';
import { PlantDescription, PlantReport } from 'src/interfaces/plant.interface';
import { Weather } from 'src/interfaces/weather.interface';
@Injectable()
export class LogicService {

    constructor(
        private readonly plantService: PlantService,
        private readonly groqService: GroqService,
        private readonly meteomaticsService: MeteomaticsService
    ){}

    async analyzePlants(analyzeRequest: AnalyzeRequest): Promise<PlantStat[]> {
        console.log(`analyzeRequest: ${analyzeRequest}`);

        const analyzedPlants: PlantStat[] = [];

        let weatherData: Weather[] = await this.getWeatherVariation(analyzeRequest.duration, analyzeRequest.address);
        this.adjustWeatherData(weatherData);
        const plants = analyzeRequest.plants;
        Logger.log(`plants: ${plants}`);
        
        for (let plant of plants) {
            const plantDescription: PlantDescription = this.setPlantDescription(await this.plantService.getPlantById(plant.id));
            const report: PlantReport =  await this.groqService.generatePlantReport(plantDescription, weatherData);
            const analyzedPlant = {
                plant: plantDescription,
                report: report
            }
            analyzedPlants.push(analyzedPlant);
        }

        analyzedPlants.forEach(plant => {
            if (plant.plant.fruitingSeason === undefined) {
                plant.plant.fruitingSeason = null;
            }
        });

        return analyzedPlants;
    }

    async getWeatherVariation(interval: number, address: Address): Promise<Weather[]> {
        return this.meteomaticsService.getWeatherVariation(interval, address);
    }

    
    private adjustWeatherData(weatherData: Weather[]): void {
        if (weatherData.length > 10) {
            const reducedWeatherData: Weather[] = [];
            for (let i = 0; i < weatherData.length; i += 7) {
                const chunk = weatherData.slice(i, i + 7);
                const averageWeather = this.calculateAverageWeather(chunk);
                reducedWeatherData.push(averageWeather);
            }
            weatherData = reducedWeatherData;
        }
    
        for (let weather of weatherData) {
            weather.temperatureC = Math.round(weather.temperatureC);
            weather.precipitationMM = Math.round(weather.precipitationMM);
            weather.relativeHumidity = Math.round(weather.relativeHumidity);
        }
    }
    
    private calculateAverageWeather(chunk: Weather[]): Weather {
        const length = chunk.length;
        const averageWeather: Weather = {
            date: chunk[0].date,
            temperatureC: chunk.reduce((sum, weather) => sum + weather.temperatureC, 0) / length,
            precipitationMM: chunk.reduce((sum, weather) => sum + weather.precipitationMM, 0) / length,
            relativeHumidity: chunk.reduce((sum, weather) => sum + weather.relativeHumidity, 0) / length,
        };
        return averageWeather;
    }

    private setPlantDescription(plant: any): PlantDescription {
        return {
            id: plant.id,
            name: plant.common_name,
            type: plant.type, //exmple tree
            cycle: plant.cycle, //example perennial
            watering: plant.watering,
            sunlight: plant.sunlight, // array of sunlight ex: Part shade
            fruitingSeason: plant.fruiting_season, // season of fruiting ex: summer
            maintenance: plant.maintenance, // maintenance ex: low
            growthRate: plant.growth_rate, // growth rate ex: fast
            description: plant.description,
            careLevel: plant.care_level, // care level ex: Medium
            image: plant.default_image.regular_url,

        }
    }


}
