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
    sunlight: string[];
    fruitingSeason: string | null;
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