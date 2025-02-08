import { Test, TestingModule } from '@nestjs/testing';
import { MeteomaticsService } from './meteomatics.service';

describe('MeteomaticsService', () => {
  let service: MeteomaticsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MeteomaticsService],
    }).compile();

    service = module.get<MeteomaticsService>(MeteomaticsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
