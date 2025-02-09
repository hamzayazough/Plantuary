import { Controller, Get, HttpException, HttpStatus, Query, Body, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { Address } from './interfaces/address.interface';
import Groq from 'groq-sdk';
import { LogicService } from './services/logic/logic.service';
import { PlantStat, TestConnectionDto } from './interfaces/report.interface';
import { AnalyzeRequest } from './interfaces/analyze.interface';
import { Section } from './interfaces/section.interface';
@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly logicService: LogicService
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Post('analyze-plants')
  async analyzePlants(@Body() analyzeRequest: AnalyzeRequest): Promise<PlantStat[]> {
    try {
      console.log('Analyzing plants', analyzeRequest);
      return await this.logicService.analyzePlants(analyzeRequest);
    } catch (error) {
      throw new HttpException('Error analyzing plants', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('test')
  async testConnection(@Body() testConnectionDto: TestConnectionDto): Promise<any> {
    try {
      const { interval, address } = testConnectionDto;
      console.log('Testing connection with Meteomatics API', interval, address);
      return await this.logicService.getWeatherVariation(interval, address);
    } catch (error) {
      throw new HttpException(
        'Error testing connection with Meteomatics API',
        HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }
}