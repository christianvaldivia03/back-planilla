import { IsString } from 'class-validator';

export class searchListaDto {
  @IsString()
  entidad: string;
}
