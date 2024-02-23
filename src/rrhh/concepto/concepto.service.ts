import { Injectable } from '@nestjs/common';
import { CreateConceptoDto } from './dto/create-concepto.dto';
import { UpdateConceptoDto } from './dto/update-concepto.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Concepto } from './entities/concepto.entity';
import { Repository, ILike } from 'typeorm';

@Injectable()
export class ConceptoService {
  constructor(
    @InjectRepository(Concepto)
    private readonly conceptoRepository: Repository<Concepto>,
  ) {}

  create(createConceptoDto: CreateConceptoDto) {
    return createConceptoDto;
  }

  async searchList(searchConceptoDto: UpdateConceptoDto) {
    const objSearch = searchConceptoDto;
    const objWhere: {
      id_concepto?: number;
      est_conc?: number;
      tipo_conc?: number;
      cod_conc?: any;
      nomb_conc?: any;
      id_sub_tipo_conc?: number;
      afecto_essalud?: boolean;
      afecto_previsional?: boolean;
      afecto_impuesto?: boolean;
      bonif_ext?: boolean;
    } = {};

    if (objSearch.id_concepto) objWhere.id_concepto = objSearch.id_concepto;

    if (objSearch.est_conc) objWhere.est_conc = objSearch.est_conc;

    if (objSearch.tipo_conc) objWhere.tipo_conc = objSearch.tipo_conc;

    if (objSearch.cod_conc)
      objWhere.cod_conc = ILike(`%${objSearch.cod_conc}%`);

    if (objSearch.nomb_conc)
      objWhere.nomb_conc = ILike(`%${objSearch.nomb_conc}%`);

    if (objSearch.id_sub_tipo_conc)
      objWhere.id_sub_tipo_conc = objSearch.id_sub_tipo_conc;

    if (objSearch.afecto_essalud)
      objWhere.afecto_essalud = objSearch.afecto_essalud;

    if (objSearch.afecto_previsional)
      objWhere.afecto_previsional = objSearch.afecto_previsional;

    if (objSearch.afecto_impuesto)
      objWhere.afecto_impuesto = objSearch.afecto_impuesto;

    if (objSearch.bonif_ext) objWhere.bonif_ext = objSearch.bonif_ext;

    console.log(objWhere);

    const concepto = await this.conceptoRepository.find({
      where: objWhere,
      order: { id_concepto: 'ASC' },
    });

    return concepto;
  }
}
