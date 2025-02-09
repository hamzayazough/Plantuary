import { Injectable } from '@nestjs/common';
import { PlantService } from './../plant/plant.service';
import { GroqService } from './../groq/groq.service';
import { MeteomaticsService } from './../meteomatics/meteomatics.service';
import { Address } from 'src/interfaces/address.interface';
import Groq from 'groq-sdk';
import { TestConnectionDto } from 'src/interfaces/report.interface';
import { AnalyzeRequest } from 'src/interfaces/analyze.interface';
import { interval } from 'rxjs';
import { Section } from 'src/interfaces/section.interface';
import { PlantDescription } from 'src/interfaces/plant.interface';
@Injectable()
export class LogicService {

    constructor(
        private readonly plantService: PlantService,
        private readonly groqService: GroqService,
        private readonly meteomaticsService: MeteomaticsService
    ){}

    async analyzePlants(analyzeRequest: AnalyzeRequest): Promise<any> {
        const analyzedPlants: any[] = [];

        const weatherData = await this.getWeatherVariation(analyzeRequest.duration, analyzeRequest.address);
        const plants = analyzeRequest.plants;
        for (let plant of plants) {
            const plantGuide: Section[] = await this.getPlantGuideById(plant.id);
            console.log("Plant Guide");
            const plantDescription: PlantDescription = this.setPlantDescription(await this.plantService.getPlantById(plant.id), plantGuide);
            console.log("Plant Description");
            const analyzedPlant = this.groqService.generatePlantReport(plantDescription);
            console.log("Analyzed Plant");
            analyzedPlants.push(analyzedPlant);
        }

        return analyzedPlants;
    }

    async getWeatherVariation(interval: number, address: Address): Promise<any> {
        return this.meteomaticsService.getWeatherVariation(interval, address);
    }


    async generatePlantReport(id: number): Promise<any> {
        const plant = await this.plantService.getPlantById(id);
        return this.groqService.generatePlantReport(plant);
    }

    private async getPlantGuideById(id: number): Promise<any> {
        return this.plantService.getPlantGuideById(id);
    }


    private setPlantDescription(plant: any, plantGuide: Section[]): PlantDescription {
        return {
            id: plant.id,
            name: plant.common_name,
            type: plant.type, //exmple tree
            cycle: plant.cycle, //example perennial
            watering: plant.watering,
            depthWaterRequired: {
                unit: plant.depth_water_requirement.unit,
                value: plant.depth_water_requirement.value
            },
            volumeWaterRequired: {
                unit: plant.volume_water_requirement.unit,
                value: plant.volume_water_requirement.value
            },
            sunlight: plant.sunlight, // array of sunlight ex: Part shade
            pruningMonths: plant.pruning_month, // array of months
            pruningCount: {
                amount: plant.pruning_count.amount, //example 1
                interval: plant.pruning_count.interval //example yearly
            },
            attracts: plant.attracts, // array of animals ex: [bees]
            flowering_season: plant.flowering_season, // season of flowering ex: spring
            fruiting_season: plant.fruiting_season, // season of fruiting ex: summer
            maintenance: plant.maintenance, // maintenance ex: low
            growthRate: plant.growth_rate, // growth rate ex: fast
            saltTolerant: plant.salt_tolerant, // salt tolerant ex: true
            description: plant.description,
            careLevel: plant.care_level, // care level ex: Medium
            guide: plantGuide

        }
    }


}
