import { Address } from "./address.interface";
import { AnalysedCrops, Crops } from "./crops-interface";
import { PlantReq } from "./plant.interface";

export interface AnalyzeRequest {
    address: Address;
    duration: number; // in days
    plants: PlantReq[];
}

export interface AnalyseResult {
    crops: AnalysedCrops[];
}