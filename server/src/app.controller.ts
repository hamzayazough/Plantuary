import { Controller, Get, HttpException, HttpStatus, Query } from '@nestjs/common';
import { MeteomaticsService } from './services/meteomatics/meteomatics.service';
import { AppService } from './app.service';
import { GroqService } from './services/groq/groq.service';
import { PlantService } from './services/plant/plant.service';
import Groq from 'groq-sdk';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly meteomaticsService: MeteomaticsService,
    private readonly groq: GroqService,
    private readonly plantService: PlantService
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('test')
  async testConnection(): Promise<string> {
    try {
      console.log('Testing connection with Meteomatics API');
      const token = await this.meteomaticsService.getToken();
      return `Connection successful. Token: ${token}`;
    } catch (error) {
      throw new HttpException(
        'Error testing connection with Meteomatics API',
        HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }

  @Get('groq')
  async getGroqChatCompletion(): Promise<Groq.Chat.Completions.ChatCompletion> {
    try {
      console.log('Getting GROQ chat completion');
      const completion = await this.groq.getGroqChatCompletion();
      return completion;
    } catch (error) {
      throw new HttpException(
        'Error getting GROQ chat completion',
        HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }

  @Get('plants')
  async getPlants(@Query('name') name: string): Promise<any> {
    try {
      console.log(`Fetching plants with name: ${name}`);
      const plants = await this.plantService.getPlantsByName(name);
      return plants;
    } catch (error) {
      throw new HttpException(
        'Error fetching plants',
        HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }
}
