import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { Section } from 'src/interfaces/section.interface';

@Injectable()
export class PlantService {
  private readonly API_URL = 'https://perenual.com/api';
  private readonly API_KEY = process.env.PERENUAL_API;

  constructor(private readonly httpService: HttpService) {}

  async getPlantsByName(name: string): Promise<any> {
    try {
      const url = `${this.API_URL}/species-list?key=${this.API_KEY}&q=${name}&per_page=10`;
      const response = await firstValueFrom(this.httpService.get(url));
      return response.data;
    } catch (error) {
      throw new HttpException('Failed to fetch plant list', HttpStatus.BAD_REQUEST);
    }
  }

  async getPlantGuideById(id: number): Promise<Section[]> {
    try {
      const url = `${this.API_URL}/species-care-guide-list?key=${this.API_KEY}&species_id=${id}`;
      const response = await firstValueFrom(this.httpService.get(url));
      return response.data.section;
    } catch (error) {
      throw new HttpException('Failed to fetch plant guide', HttpStatus.BAD_REQUEST);
    }
  }

  async getPlantById(id: number): Promise<any> {
    try {
      const url = `${this.API_URL}/species/details/${id}?key=${this.API_KEY}`;
      const response = await firstValueFrom(this.httpService.get(url));
      return response.data;
    } catch (error) {
      throw new HttpException('Failed to fetch plant details', HttpStatus.BAD_REQUEST);
    }
  }

}