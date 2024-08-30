USE [CNPV_2018]
GO

/****** Object:  View [dbo].[Manzanas_Antioquia]    Script Date: 29/08/2024 7:13:33 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Manzanas_Antioquia]
AS
SELECT CONCAT(U_DPTO, [U_MPIO], [UA_CLASE], [U_SECT_RUR], [U_SECC_RUR], [UA2_CPOB], [U_SECT_URB], [U_SECC_URB], [U_MZA]) AS COD_MANZANA,
       CONCAT(COD_ENCUESTAS, [U_DPTO], [U_MPIO], [UA_CLASE], [U_EDIFICA], [U_VIVIENDA]) AS skVivienda,
       [UA1_LOCALIDAD],
       [UA2_CPOB],
       [U_EDIFICA],
       [COD_ENCUESTAS],
       [U_VIVIENDA]
FROM   [CNPV_2018].[dbo].[MGN_Antioquia];

GO


