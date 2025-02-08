import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MeteomaticsService } from './services/meteomatics/meteomatics.service';
import { MeteomaticsController } from './controllers/meteomatics/meteomatics.controller';
import { GroqService } from './services/groq/groq.service';
import { PlantService } from './services/plant/plant.service';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [HttpModule],
  controllers: [AppController, MeteomaticsController],
  providers: [AppService, MeteomaticsService, GroqService, PlantService],
})
export class AppModule {}
