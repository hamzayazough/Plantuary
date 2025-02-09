import { Section } from "./section.interface";

export interface PlantReq {
    id: number;
    quantity: number;
}

export interface PlantDescription {
    id: number;
    name: string;
    type: string;
    cycle: string;
    watering: string;
    depthWaterRequired: {
      unit: string;
      value: number;
    };
    volumeWaterRequired: {
      unit: string;
      value: number;
    };
    sunlight: string[];
    attracts: string[];
    fruiting_season: string;
    maintenance: string;
    growthRate: string;
    description: string;
    careLevel: string;
    image: string;
  }


  export interface PlantReport {
    feasibility: number;
    suggestions: string[];
    perfectTemperature: number;
    perfectWateringFrequency: string;
    perfectHumidity: number;
  }

  export interface PlantInsight {
    temperatureHigher: string;
    temperatureLower: string;
    humidityHigher: string;
    humidityLower: string;
    precipitationHigher: string;
    precipitationLower: string;
  }