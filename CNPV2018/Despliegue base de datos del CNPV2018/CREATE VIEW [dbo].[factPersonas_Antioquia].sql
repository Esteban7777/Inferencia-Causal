USE [CNPV_2018]
GO

/****** Object:  View [dbo].[factPersonas_Antioquia]    Script Date: 29/08/2024 7:12:54 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[factPersonas_Antioquia]
AS
SELECT CONCAT(p.COD_ENCUESTAS, p.[U_DPTO], p.[U_MPIO], p.[UA_CLASE], p.[U_EDIFICA], p.[U_VIVIENDA]) AS skVivienda,
       CONCAT(p.COD_ENCUESTAS, p.[U_DPTO], p.[U_MPIO], p.[UA_CLASE], p.[U_EDIFICA], p.[U_VIVIENDA], p.[P_NRO_PER]) AS skPersona,
       m.[COD_MANZANA],
       CASE WHEN PA_LUG_NAC = 3 THEN 1 ELSE 0 END AS flagMigranteInternacional,
       CASE WHEN PA_LUG_NAC = 2 THEN 1 ELSE 0 END AS flagMigranteIntermunicipal,
       CASE WHEN [P_EDADR] > 3 THEN 1 ELSE 0 END AS flagPET,
       CASE WHEN [P_TRABAJO] = 1
                 OR [P_TRABAJO] = 2
                 OR [P_TRABAJO] = 3 THEN 1 ELSE 0 END AS flagOcupado,
       CASE WHEN [P_EDADR] > 3
                 AND [P_TRABAJO] = 4 THEN 1 ELSE 0 END AS flagDesempleado,
       CASE WHEN [P_EDADR] > 3
                 AND ([P_TRABAJO] > 4
                      OR [P_TRABAJO] = 0) THEN 1 ELSE 0 END AS flagInactivo,
       e.[Años_acumulados] AS EducationYears,
       p.[TIPO_REG],
       p.[U_DPTO],
       p.[U_MPIO],
       p.[UA_CLASE],
       p.[U_EDIFICA],
       p.[COD_ENCUESTAS],
       p.[U_VIVIENDA],
       p.[P_NROHOG],
       p.[P_NRO_PER],
       p.[P_SEXO],
       p.[P_EDADR],
       p.[P_PARENTESCOR],
       p.[PA1_GRP_ETNIC],
       p.[PA11_COD_ETNIA],
       p.[PA12_CLAN],
       p.[PA21_COD_VITSA],
       p.[PA22_COD_KUMPA],
       p.[PA_HABLA_LENG],
       p.[PA1_ENTIENDE],
       p.[PB_OTRAS_LENG],
       p.[PB1_QOTRAS_LENG],
       p.[PA_LUG_NAC],
       p.[PA_VIVIA_5ANOS],
       p.[PA_VIVIA_1ANO],
       p.[P_ENFERMO],
       p.[P_QUEHIZO_PPAL],
       p.[PA_LO_ATENDIERON],
       p.[PA1_CALIDAD_SERV],
       p.[CONDICION_FISICA],
       p.[P_ALFABETA],
       p.[PA_ASISTENCIA],
       p.[P_NIVEL_ANOSR],
       p.[P_TRABAJO],
       p.[P_EST_CIVIL],
       p.[PA_HNV],
       p.[PA1_THNV],
       p.[PA2_HNVH],
       p.[PA3_HNVM],
       p.[PA_HNVS],
       p.[PA1_THSV],
       p.[PA2_HSVH],
       p.[PA3_HSVM],
       p.[PA_HFC],
       p.[PA1_THFC],
       p.[PA2_HFCH],
       p.[PA3_HFCM],
       p.[PA_UHNV],
       p.[PA1_MES_UHNV],
       p.[PA2_ANO_UHNV]
FROM   [CNPV_2018].[dbo].[Personas_Antioquia] AS p
       LEFT OUTER JOIN
       [CNPV_2018].[dbo].[Manzanas_Antioquia] AS m
       ON CONCAT(p.COD_ENCUESTAS, p.[U_DPTO], p.[U_MPIO], p.[UA_CLASE], p.[U_EDIFICA], p.[U_VIVIENDA]) = m.skVivienda
       INNER JOIN
       [CNPV_2018].[dbo].[DimNivelEducativo] AS e
       ON e.[skNivelEducativo] = p.[P_NIVEL_ANOSR];

GO


