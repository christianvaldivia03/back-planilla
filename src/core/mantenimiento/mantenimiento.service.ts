import { Injectable } from '@nestjs/common';
import { List } from './entities/list.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class MantenimientoService {
  constructor(
    @InjectRepository(List)
    private readonly listRepository: Repository<List>,
  ) {}

  async searchList(searchListDto: any) {
    const path = searchListDto.entidad;
    // const path = 'DOC-IDENTIDAD,PAIS';
    const datos = path.split(',');
    let arregloObjetos = {};

    for (const data of datos) {
      const lista = await this.listRepository.findBy({ entidad: data });
      // const obj = {
      //   ,
      // };
      arregloObjetos = { ...arregloObjetos, [data]: lista };
      // arregloObjetos.push(obj);
    }

    // const lista = await this.listRepository.findBy({ entidad: datos });

    // const arregloObjetos = {
    //   [datos]: lista,
    // };
    // console.log(arregloObjetos);

    return arregloObjetos;
  }
}
