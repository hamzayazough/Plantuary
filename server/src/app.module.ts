import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MeteomaticsService } from './services/meteomatics/meteomatics.service';
import { MeteomaticsController } from './controllers/meteomatics/meteomatics.controller';
import { GroqService } from './services/groq/groq.service';
import { PlantService } from './services/plant/plant.service';
import { HttpModule } from '@nestjs/axios';
import { LogicService } from './services/logic/logic.service';

@Module({
  imports: [HttpModule],
  controllers: [AppController],
  providers: [AppService, MeteomaticsService, GroqService, PlantService, LogicService],
})
export class AppModule {}
