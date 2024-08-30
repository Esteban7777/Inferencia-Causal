USE [CNPV_2018]
GO

/****** Object:  View [dbo].[factViviendas_Antioquia]    Script Date: 29/08/2024 7:13:11 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[factViviendas_Antioquia]
AS
SELECT CONCAT(v.COD_ENCUESTAS, v.[U_DPTO], v.[U_MPIO], v.[UA_CLASE], v.[U_EDIFICA], v.[U_VIVIENDA]) AS skVivienda,
       CONCAT(v.[COD_ENCUESTAS], v.[U_DPTO], v.[U_MPIO], v.[UA_CLASE], v.[U_VIVIENDA]) AS skHogarVivienda,
       m.COD_MANZANA,
       CASE WHEN v.[V_MAT_PARED] > 3 THEN 1 ELSE 0 END AS flagParedesPrecarias,
       CASE WHEN v.[V_MAT_PISO] > 3 THEN 1 ELSE 0 END AS flagPisosPrecarios,
       CASE WHEN v.[VB_ACU] = 2 THEN 1 ELSE 0 END AS flagFaltaAcueducto,
       CASE WHEN v.[VC_ALC] = 2 THEN 1 ELSE 0 END AS flagFaltaAlcantarillado,
       CASE WHEN v.[VA1_ESTRATO] IS NULL
                 OR v.[VA1_ESTRATO] = 9 THEN 0 ELSE v.[VA1_ESTRATO] END AS estratoNumerico,
       v.[TIPO_REG],
       v.[U_DPTO],
       v.[U_MPIO],
       v.[UA_CLASE],
       v.[U_EDIFICA],
       v.[COD_ENCUESTAS],
       v.[U_VIVIENDA],
       v.[UVA_ESTATER],
       v.[UVA1_TIPOTER],
       v.[UVA2_CODTER],
       v.[UVA_ESTA_AREAPROT],
       v.[UVA1_COD_AREAPROT],
       v.[UVA_USO_UNIDAD],
       v.[V_TIPO_VIV],
       v.[V_CON_OCUP],
       v.[V_TOT_HOG],
       v.[V_MAT_PARED],
       v.[V_MAT_PISO],
       v.[VA_EE],
       v.[VA1_ESTRATO],
       v.[VB_ACU],
       v.[VC_ALC],
       v.[VD_GAS],
       v.[VE_RECBAS],
       v.[VE1_QSEM],
       v.[VF_INTERNET],
       v.[V_TIPO_SERSA],
       v.[L_TIPO_INST],
       v.[L_EXISTEHOG],
       v.[L_TOT_PERL]
FROM   [CNPV_2018].[dbo].[Viviendas_Antioquia] AS v
       LEFT OUTER JOIN
       [CNPV_2018].[dbo].[Manzanas_Antioquia] AS m
       ON m.skVivienda = CONCAT(v.COD_ENCUESTAS, v.[U_DPTO], v.[U_MPIO], v.[UA_CLASE], v.[U_EDIFICA], v.[U_VIVIENDA]);

GO


