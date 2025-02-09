import { Controller, Get, HttpException, HttpStatus, Query, Body, Post, Logger } from '@nestjs/common';
import { Address } from './interfaces/address.interface';
import Groq from 'groq-sdk';
import { LogicService } from './services/logic/logic.service';
import { PlantStat, TestConnectionDto } from './interfaces/report.interface';
import { AnalyzeRequest } from './interfaces/analyze.interface';
import { Section } from './interfaces/section.interface';
import { Weather } from './interfaces/weather.interface';
@Controller()
export class AppController {
  constructor(
    private readonly logicService: LogicService
  ) {}


  @Post('analyze-plants')
  async analyzePlants(@Body() analyzeRequest: AnalyzeRequest): Promise<PlantStat[]> {
    try {
      const temp = await this.logicService.analyzePlants(analyzeRequest);
      // Logger.log(`temp: ${temp}`);
      console.log(`temp: ${temp}`);

      return temp;
    } catch (error) {
      throw new HttpException('Error analyzing plants', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('calendar')
  async testConnection(@Body() testConnectionDto: TestConnectionDto): Promise<Weather[]> {
    try {
      const { interval, address } = testConnectionDto;
      return await this.logicService.getWeatherVariation(interval, address);
    } catch (error) {
      throw new HttpException(
        'Error testing connection with Meteomatics API',
        HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }

  // @Post('insight')
  // async getInsight(@Body() address: Address): Promise<Section> {
  //   try {
  //     return await this.logicService.getInsightForNextWeek(address);
  //   } catch (error) {
  //     throw new HttpException('Error getting insight', HttpStatus.INTERNAL_SERVER_ERROR);
  //   }
  // }
}