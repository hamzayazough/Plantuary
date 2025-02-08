import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MeteomaticsService } from './services/meteomatics/meteomatics.service';
import { MeteomaticsController } from './controllers/meteomatics/meteomatics.controller';
import { GroqService } from './services/groq/groq.service';

@Module({
  imports: [],
  controllers: [AppController, MeteomaticsController],
  providers: [AppService, MeteomaticsService, GroqService],
})
export class AppModule {}
