USE [CNPV_2018]
GO

/****** Object:  View [dbo].[factMedellinManzanasConsolidado]    Script Date: 29/08/2024 7:12:35 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[factMedellinManzanasConsolidado]
AS
SELECT   p.[COD_MANZANA],
         COUNT(p.skPersona) AS POBLACION,
         SUM(p.flagPET) AS PET,
         SUM(p.flagInactivo) AS Inactivos,
         SUM(p.[flagDesempleado]) AS Desempleados,
         SUM(p.flagOcupado) AS Ocupados,
         SUM(p.[flagDesempleado]) + SUM(p.[flagOcupado]) AS PEA,
         CASE WHEN (SUM(p.[flagDesempleado]) + SUM(p.[flagOcupado])) = 0 THEN 0 ELSE CAST (SUM(p.[flagDesempleado]) AS FLOAT) / CAST (SUM(p.[flagDesempleado]) + SUM(p.[flagOcupado]) AS FLOAT) END AS TasaDesempleo,
         SUM(p.[flagMigranteInternacional]) AS MigrantesInternacionales,
         CAST (SUM(p.[flagMigranteInternacional]) AS FLOAT) / CAST (COUNT(p.skPersona) AS FLOAT) AS ProporcionMigrantesInternacionales,
         SUM(p.[flagMigranteIntermunicipal]) AS MigrantesIntermunicipales,
         CAST (SUM(p.[flagMigranteIntermunicipal]) AS FLOAT) / CAST (COUNT(p.skPersona) AS FLOAT) AS ProporcionMigranteIntermunicipales,
         CAST (sum(p.[EducationYears]) AS FLOAT) / CAST (COUNT(p.skPersona) AS FLOAT) AS EducacionPromedio,
         count(h.skHogar) AS TOTAL_HOGARES,
         sum(h.[flagParedesPrecarias]) AS ParedesPrecarias,
         sum(CAST (h.[flagParedesPrecarias] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS PorcentajeParedesPrecarias,
         sum(h.[flagPisosPrecarios]) AS PisosPrecarios,
         sum(CAST (h.[flagPisosPrecarios] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS PorcentajePisosPrecarios,
         sum(h.[flagHacinamiento]) AS PrecariedadHacinamiento,
         sum(CAST (h.[flagHacinamiento] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS PorcentajePrecariedadHacinamiento,
         sum(h.[flagFaltaAcueducto]) AS PrecariedadAcueducto,
         sum(CAST (h.[flagFaltaAcueducto] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS PorcentajePrecariedadAcueducto,
         sum(CAST (h.[precariedadVivienda] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS PrecariedadPromedio,
         sum(CAST (h.[estratoNumerico] AS FLOAT)) / count(CAST (h.skHogar AS FLOAT)) AS EstratoPromedio
FROM     [CNPV_2018].[dbo].[factPersonas_Antioquia] AS p
         INNER JOIN
         [CNPV_2018].[dbo].[factHogares_Antioquia] AS h
         ON h.COD_MANZANA = p.COD_MANZANA
WHERE    p.[U_MPIO] = 001
GROUP BY p.[COD_MANZANA];

GO


