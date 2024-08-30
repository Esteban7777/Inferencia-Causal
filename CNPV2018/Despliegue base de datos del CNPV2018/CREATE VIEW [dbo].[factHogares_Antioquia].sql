USE [CNPV_2018]
GO

/****** Object:  View [dbo].[factHogares_Antioquia]    Script Date: 29/08/2024 7:12:15 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[factHogares_Antioquia]
AS
SELECT CONCAT(h.[COD_ENCUESTAS], h.[U_DPTO], h.[U_MPIO], h.[UA_CLASE], h.[U_VIVIENDA]) AS skHogarVivienda,
       CONCAT(h.[COD_ENCUESTAS], h.[U_DPTO], h.[U_MPIO], h.[UA_CLASE], h.[U_VIVIENDA], h.[H_NROHOG]) AS skHogar,
       CASE WHEN h.[H_NRO_DORMIT] = 99 THEN NULL ELSE CAST (h.[H_NRO_DORMIT] AS INT) / CAST (h.[HA_TOT_PER] AS INT) END AS personasHabitacion,
       CASE WHEN h.[H_NRO_DORMIT] = 99 THEN NULL ELSE CASE WHEN (CAST (h.[H_NRO_DORMIT] AS INT) / CAST (h.[HA_TOT_PER] AS INT)) > 3 THEN 1 ELSE 0 END END AS flagHacinamiento,
       v.COD_MANZANA,
       v.flagParedesPrecarias,
       v.flagPisosPrecarios,
       v.flagFaltaAcueducto,
       v.flagFaltaAlcantarillado,
       v.flagParedesPrecarias + v.flagPisosPrecarios + v.flagFaltaAcueducto + v.flagFaltaAlcantarillado + CASE WHEN (CAST (h.[H_NRO_DORMIT] AS INT) / CAST (h.[HA_TOT_PER] AS INT)) > 3 THEN 1 ELSE 0 END AS precariedadVivienda,
       v.estratoNumerico,
       h.[TIPO_REG],
       h.[U_DPTO],
       h.[U_MPIO],
       h.[UA_CLASE],
       h.[COD_ENCUESTAS],
       h.[U_VIVIENDA],
       h.[H_NROHOG],
       h.[H_NRO_CUARTOS],
       h.[H_NRO_DORMIT],
       h.[H_DONDE_PREPALIM],
       h.[H_AGUA_COCIN],
       h.[HA_NRO_FALL],
       h.[HA_TOT_PER]
FROM   [CNPV_2018].[dbo].[Hogares_Antioquia] AS h
       LEFT OUTER JOIN
       [dbo].[factViviendas_Antioquia] AS v
       ON v.skHogarVivienda = CONCAT(h.[COD_ENCUESTAS], h.[U_DPTO], h.[U_MPIO], h.[UA_CLASE], h.[U_VIVIENDA]);

GO


