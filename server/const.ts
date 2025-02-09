import { PlantDescription } from "src/interfaces/plant.interface";
import { Weather } from "src/interfaces/weather.interface";

export function generatePlantPrompt(plant: PlantDescription, weather: Weather[]): string {
    return `
  You are a highly knowledgeable botanist and agronomist. You have access to detailed plant information and current weather data. Use all the provided data to generate an accurate plant report.
  
  Below are the inputs:
  
  Plant Description:
  {
    "id": ${plant.id},
    "name": "${plant.name}",
    "type": "${plant.type}",
    "cycle": "${plant.cycle}",
    "watering": "${plant.watering}",
    "depthWaterRequired": {
      "unit": "${plant.depthWaterRequired.unit}",
      "value": ${plant.depthWaterRequired.value}
    },
    "volumeWaterRequired": {
      "unit": "${plant.volumeWaterRequired.unit}",
      "value": ${plant.volumeWaterRequired.value}
    },
    "sunlight": ${JSON.stringify(plant.sunlight)},
    "attracts": ${JSON.stringify(plant.attracts)},
    "fruiting_season": "${plant.fruiting_season}",
    "maintenance": "${plant.maintenance}",
    "growthRate": "${plant.growthRate}",
    "description": "${plant.description}",
    "careLevel": "${plant.careLevel}",
  }
  
  Weather Data:
  ${JSON.stringify(weather, null, 2)}
  
  Based on the above information, generate a valid JSON object containing exactly these keys:
  
  1. "feasibility": A number between 0 and 100 indicating how feasible it is to grow this plant under the current weather conditions.
  2. "suggestions": An array of short, one-sentence suggestions for actions to improve the plant's growth and care, considering both its characteristics and the weather data.
  3. "perfectTemperature": The estimated ideal temperature (in °C) for optimal growth of the plant.
  4. "perfectWateringFrequency": The estimated ideal watering frequency (e.g., "Every 3 days") for the plant.
  5. "perfectHumidity": The estimated ideal humidity (as a percentage) for the plant.
  
  Do not include any extra keys or commentary. Output only the JSON object containing the keys and values mentionned above.
  
  Example of expected JSON output:
  {
    "feasibility": 85,
    "suggestions": [
      "Water the plant in the early morning to reduce evaporation.",
      "Provide partial shade during peak sunlight hours.",
      "Maintain consistent moisture without overwatering."
    ],
    "perfectTemperature": 23,
    "perfectWateringFrequency": "Every 3 days",
    "perfectHumidity": 65
  }
    `.trim();
  }
  