import { PartialType } from '@nestjs/mapped-types';
import { SearchPlanillaTrabajador } from './search-planilla-concepto.dto';
import { IsArray } from 'class-validator';

export class SearchArrayPlanilla extends PartialType(SearchPlanillaTrabajador) {
  @IsArray()
  data: SearchPlanillaTrabajador[];
}
