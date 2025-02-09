import { Address } from "./address.interface";
import { PlantDescription, PlantReport } from "./plant.interface";
export class TestConnectionDto {
  interval: number;
  address: Address;
}

export interface PlantStat {
  report: PlantReport;
  plant: PlantDescription;
}