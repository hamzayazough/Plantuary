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
    pruningMonths: string[];
    pruningCount: {
      amount: number;
      interval: string;
    };
    attracts: string[];
    flowering_season: string;
    fruiting_season: string;
    maintenance: string;
    growthRate: string;
    saltTolerant: boolean;
    description: string;
    careLevel: string;
    guide: Section[]
  }