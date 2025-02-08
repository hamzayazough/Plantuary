import { Controller, Get, HttpException, HttpStatus } from '@nestjs/common';
import { MeteomaticsService } from 'src/services/meteomatics/meteomatics.service';
@Controller('meteomatics')
export class MeteomaticsController {
    constructor(private readonly meteomaticsService: MeteomaticsService) {}
}
