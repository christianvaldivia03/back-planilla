import { Injectable } from '@nestjs/common';
import { List } from './entities/list.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { PlanillaTipo } from 'src/rrhh/planilla/entities/planillatipo.entity';
import { EmployeeType } from 'src/rrhh/trabajador/entities/trabajadortipo.entity';
import { Anio } from './entities/anio.entity';
import { Mes } from './entities/mes.entity';

@Injectable()
export class MantenimientoService {
  constructor(
    @InjectRepository(List)
    private readonly listRepository: Repository<List>,
    @InjectRepository(PlanillaTipo)
    private readonly planillaTipoRepository: Repository<PlanillaTipo>,
    @InjectRepository(EmployeeType)
    private readonly employeeTypeRepository: Repository<EmployeeType>,
    @InjectRepository(Anio)
    private readonly anioTypeRepository: Repository<Anio>,
    @InjectRepository(Mes)
    private readonly mesRepository: Repository<Mes>,
  ) {}

  async searchList(searchListDto: any) {
    const path = searchListDto.entidad;
    const datos = path.split(',');
    let arregloObjetos = {};
    for (const data of datos) {
      const lista = await this.listRepository.findBy({ entidad: data });
      arregloObjetos = { ...arregloObjetos, [data]: lista };
    }
    return arregloObjetos;
  }

  async listTypePlanilla() {
    return await this.planillaTipoRepository.find({
      where: { est_tipo_pla: 1 },
      order: { cod_tipo_pla: 'ASC' },
    });
  }

  async listTypeEmployee() {
    return await this.employeeTypeRepository.find({
      where: { est_tipo_trabajador: 1 },
      order: { cod_tipo_trabajador: 'ASC' },
    });
  }

  async listStateEmployee() {
    return await this.listRepository.find({
      where: { entidad: 'PERSONAL-ESTADO' },
      order: { cod_lista: 'ASC' },
    });
  }

  async listYear() {
    return await this.anioTypeRepository.find({
      order: { id_anio: 'ASC' },
    });
  }

  async listMonth() {
    return await this.mesRepository.find({
      order: { id_mes: 'ASC' },
    });
  }
}
