import { Injectable } from '@nestjs/common';
import { HttpException, HttpStatus } from '@nestjs/common';
import Groq from 'groq-sdk';
import * as dotenv from 'dotenv';
import { generatePlantPrompt } from './../../../const';
import { PlantDescription, PlantReport } from 'src/interfaces/plant.interface';
import { Weather } from 'src/interfaces/weather.interface';

dotenv.config();
@Injectable()
export class GroqService {
  private readonly groq = new Groq({ apiKey: process.env.GROQ_API });
  private readonly MAX_ATTEMPTS = 5;

  async generatePlantReport(plant: PlantDescription, weatherData: Weather[]): Promise<PlantReport> {
    let attempts = 0;
    let plantReport: PlantReport | null = null;

    while (attempts < this.MAX_ATTEMPTS && !plantReport) {
      attempts++;
      const content = generatePlantPrompt(plant, weatherData);
      try {
        const response = await this.groq.chat.completions.create({
          messages: [
            {
              role: 'user',
              content: content,
            },
          ],
          model: 'deepseek-r1-distill-llama-70b',
        });

        // Get the generated text from the response.
        const completionText = response.choices[0].message.content;
        if (!completionText) {
          throw new HttpException('Failed to generate plant report', HttpStatus.INTERNAL_SERVER_ERROR);
        }

        // Extract the JSON block from the response.
        const jsonMatch = completionText.match(/{[\s\S]*}/);
        if (!jsonMatch) {
          throw new HttpException('No valid JSON found in the response', HttpStatus.INTERNAL_SERVER_ERROR);
        }
        const jsonString = jsonMatch[0];

        // Parse the extracted JSON string.
        const parsed = JSON.parse(jsonString);

        // Validate if the parsed output matches our expected PlantReport structure.
        if (this.validatePlantReport(parsed)) {
          plantReport = parsed;
          break;
        } else {
          console.warn(`Attempt ${attempts}: Generated JSON did not pass validation. Retrying...`);
        }
      } catch (error: any) {
        console.error(`Attempt ${attempts}: Error processing plant report.`, error);

        // Check if it's a rate limit error and if a retry-after header is available.
        if (error?.status === 429 && error?.headers && error.headers['retry-after']) {
          const retryAfterSeconds = parseInt(error.headers['retry-after'], 10);
          console.warn(`Rate limit reached. Waiting for ${retryAfterSeconds} seconds before retrying...`);
          await delay(retryAfterSeconds * 1000);
        }
        // Optionally, add additional error handling for other types of errors.
      }
    }

    if (!plantReport) {
      throw new HttpException(
        'Failed to generate a valid plant report after several attempts',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return plantReport;
  }

  private validatePlantReport(report: any): report is PlantReport {
    if (typeof report !== 'object' || report === null) {
      return false;
    }

    if (typeof report.feasibility !== 'number' || report.feasibility < 0 || report.feasibility > 100) {
      return false;
    }

    if (!Array.isArray(report.suggestions) || !report.suggestions.every((s: any) => typeof s === 'string')) {
      return false;
    }

    if (typeof report.perfectTemperature !== 'number') {
      return false;
    }

    if (typeof report.perfectWateringFrequency !== 'string') {
      return false;
    }

    if (typeof report.perfectHumidity !== 'number') {
      return false;
    }

    return true;
  }
}

// Helper function for delaying execution.
function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
