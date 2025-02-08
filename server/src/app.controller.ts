import { Controller, Get, HttpException, HttpStatus } from '@nestjs/common';
import { MeteomaticsService } from './services/meteomatics/meteomatics.service';
import { AppService } from './app.service';
import { GroqService } from './services/groq/groq.service';
import Groq from 'groq-sdk';
@Controller()
export class AppController {
  constructor(private readonly appService: AppService, private readonly meteomaticsService: MeteomaticsService, private readonly groq: GroqService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

      @Get("test")
      async testConnection(): Promise<string> {
          try {
              console.log("Testing connection with Meteomatics API");
              const token = await this.meteomaticsService.getToken();
              return `Connection successful. Token: ${token}`;
          } catch (error) {
              throw new HttpException("Error testing connection with Meteomatics API", HttpStatus.INTERNAL_SERVER_ERROR);
          }
      }

      @Get('groq')
      async getGroqChatCompletion(): Promise<Groq.Chat.Completions.ChatCompletion> {
        try {
          console.log('Getting GROQ chat completion');
          const completion = await this.groq.getGroqChatCompletion();
          return completion;
        } catch (error) {
          throw new HttpException(
            'Error getting GROQ chat completion',
            HttpStatus.INTERNAL_SERVER_ERROR
          );
        }
      }
}
