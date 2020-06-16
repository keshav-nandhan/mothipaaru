import { TestBed } from '@angular/core/testing';

import { MatchfinderService } from './matchfinder.service';

describe('MatchfinderService', () => {
  let service: MatchfinderService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MatchfinderService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
