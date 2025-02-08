import { Test, TestingModule } from '@nestjs/testing';
import { MeteomaticsController } from './meteomatics.controller';

describe('MeteomaticsController', () => {
  let controller: MeteomaticsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MeteomaticsController],
    }).compile();

    controller = module.get<MeteomaticsController>(MeteomaticsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
