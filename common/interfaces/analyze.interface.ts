import { Address } from "./address.interface";
import { AnalysedCrops, Crops } from "./crops-interface";
import { Crop } from "./crops.interface";

export interface AnalyzeRequest {
    address: Address;
    crops: Crops[];
}

export interface AnalyseResult {
    crops: AnalysedCrops[];
}