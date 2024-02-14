import { Injectable, Logger } from '@nestjs/common';
import { CreatePlanillaDto } from './dto/create-planilla.dto';
import { UpdatePlanillaDto } from './dto/update-planilla.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Planilla } from './entities/planilla.entity';
import { DataSource, QueryRunner, Repository } from 'typeorm';
import { max } from 'rxjs';

@Injectable()
export class PlanillaService {
  private readonly logger = new Logger('PlanillaService');
  constructor(
    @InjectRepository(Planilla)
    private readonly planillaRepository: Repository<Planilla>,

    private readonly dataSource: DataSource,
  ) {}

  // async create(createPlanillaDto: CreatePlanillaDto) {
  //   console.log(createPlanillaDto);

  //   const maxIdPlanilla = await this.planillaRepository
  //     .createQueryBuilder('planilla')
  //     .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
  //     .getRawOne();

  //   const planillaData = await this.planillaRepository.create({
  //     ...createPlanillaDto,
  //     id_planilla: maxIdPlanilla.maxId,
  //   });

  //   console.log(planillaData);

  //   console.log(planillaData.id_planilla);

  //   await this.planillaRepository.save(planillaData);

  //   const numPlanilla = await this.planillaRepository
  //     .createQueryBuilder('a')
  //     .select(
  //       'qubytss_rrhh.get_cod_planillat(' + planillaData.id_planilla + ')',
  //       'numPlanilla',
  //     )
  //     .getRawOne();
  //   console.log(numPlanilla);
  //   return 'accion completada';
  // }

  // async create(createPlanillaDto: CreatePlanillaDto) {
  //   return await this.queryRunnerFunction(async () => {
  //     const maxIdPlanilla = await this.planillaRepository
  //       .createQueryBuilder('planilla')
  //       .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
  //       .getRawOne();

  //     const planillaData = await this.planillaRepository.create({
  //       ...createPlanillaDto,
  //       id_planilla: maxIdPlanilla.maxId,
  //     });

  //     console.log(planillaData);

  //     console.log(planillaData.id_planilla);

  //     await this.planillaRepository.save(planillaData);

  //     const numPlanilla = await this.planillaRepository
  //       .createQueryBuilder('a')
  //       .select(
  //         'qubytss_rrhh.get_cod_planillat(' + planillaData.id_planilla + ')',
  //         'numPlanilla',
  //       )
  //       .getRawOne();
  //     console.log(numPlanilla);
  //     return 'accion completada';
  //   });
  // }

  // async queryRunnerFunction(funcitonTransaction: any) {
  //   let valor;
  //   const queryRunner = this.dataSource.createQueryRunner();
  //   await queryRunner.connect();
  //   await queryRunner.startTransaction();
  //   console.log('queryRunner');
  //   try {
  //     valor = await funcitonTransaction();
  //     console.log('valor', valor);
  //     await queryRunner.commitTransaction();
  //     await queryRunner.release();
  //     return valor;
  //   } catch (error) {
  //     // console.log('error', error);
  //     await queryRunner.rollbackTransaction();
  //     await queryRunner.release();
  //     throw new Error(error);
  //   }
  //   // await queryRunner.manager.save(product);

  //   // return valor;
  // }

  async create(createPlanillaDto: CreatePlanillaDto) {
    // const queryRunner = this.dataSource.createQueryRunner();
    // await queryRunner.connect();
    // await queryRunner.startTransaction();

    try {
      const maxIdPlanilla = await this.planillaRepository
        .createQueryBuilder('planilla')
        .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
        .getRawOne();

      const planillaData = await this.planillaRepository.create({
        ...createPlanillaDto,
        id_planilla: maxIdPlanilla.maxId,
      });

      // await this.planillaRepository.save(planillaData);
      await this.planillaRepository.save(planillaData);

      const numPlanilla = await this.planillaRepository
        .createQueryBuilder('a')
        .select(
          'qubytss_rrhh.get_cod_planilla(' + planillaData.id_planilla + ')',
          'numPlanilla',
        )
        .getRawOne();
      console.log(numPlanilla);
      // await queryRunner.commitTransaction();
      // await queryRunner.release();

      return 'acción completada';
    } catch (error) {
      // await queryRunner.rollbackTransaction();
      // await queryRunner.release();
      throw error;
    }
  }

  async createPlanilla(createPlanillaDto: CreatePlanillaDto) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();
    try {
      const maxIdPlanilla = await this.planillaRepository
        .createQueryBuilder('planilla')
        .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
        .getRawOne();
      const planillaData = await this.planillaRepository.create({
        ...createPlanillaDto,
        id_planilla: maxIdPlanilla.maxId,
      });
      await queryRunner.manager.save(planillaData);
      const numPlanilla = await this.planillaRepository
        .createQueryBuilder('x')
        .select(
          'qubytss_rrhh.get_cod_planilla(' + planillaData.id_planilla + ')',
          'numPlanilla',
        )
        .getRawOne();
      await queryRunner.commitTransaction();
      await queryRunner.release();
      return 'acción completada';
    } catch (error) {
      await queryRunner.rollbackTransaction();
      await queryRunner.release();
      throw error;
    }
  }
}
