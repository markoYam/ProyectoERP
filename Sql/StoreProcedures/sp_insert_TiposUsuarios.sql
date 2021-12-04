
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_TiposUsuarios]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_insert_TiposUsuarios] AS' 
END
GO
ALTER PROCEDURE [dbo].[sp_insert_TiposUsuarios](
@nbTipoUsuario	NVARCHAR(50),
@desTipoUsuario	NVARCHAR(50)
)
AS
BEGIN
	
	DECLARE @ESTATUS INT, @MENSAJE NVARCHAR(500)

	SET @ESTATUS = 0
	SET @MENSAJE = 'No fue posible realizar la operación'

	BEGIN TRANSACTION _TRANSACTION_PROCESS
	BEGIN TRY
		
		IF NOT EXISTS(SELECT * FROM TiposUsuarios WHERE nbTipoUsuario = @nbTipoUsuario)
		BEGIN

			INSERT INTO TiposUsuarios(nbTipoUsuario,desTipoUsuario) VALUES(@nbTipoUsuario,@desTipoUsuario)

			SET @ESTATUS = 1
			SET @MENSAJE = 'Operación realizada con éxito'
		END
		ELSE
		BEGIN
			SET @ESTATUS = 0
			SET @MENSAJE = 'No fue posible realizar la operación ya que el nombre de usuario ya se encuentra en uso'
		END

		COMMIT TRANSACTION _TRANSACTION_PROCESS
	END TRY
	BEGIN CATCH
	
		SET @ESTATUS = -1
		SET @MENSAJE = 'No fue posible realizar la operación: \n'

		SET @MENSAJE += CONCAT('ERROR_NUMBER: ',ERROR_NUMBER(),' \n ')
		SET @MENSAJE += CONCAT('ERROR_STATE: ',ERROR_STATE(),' \n ')
		SET @MENSAJE += CONCAT('ERROR_SEVERITY: ',ERROR_SEVERITY(),' \n ')
		SET @MENSAJE += CONCAT('ERROR_PROCEDURE: ',ERROR_PROCEDURE(),' \n ')
		SET @MENSAJE += CONCAT('ERROR_LINE: ',ERROR_LINE(),' \n ')
		SET @MENSAJE += CONCAT('ERROR_MESSAGE: ',ERROR_MESSAGE(),' \n ')

		ROLLBACK TRANSACTION _TRANSACTION_PROCESS
	END CATCH

	SELECT @ESTATUS [ESTATUS], @MENSAJE [MENSAJE]
END

--EXECUTE STORE PROCEDURE
/*
EXEC [dbo].[sp_insert_TiposUsuarios] @nbTipoUsuario = N'ADMIN2', @desTipoUsuario = N'ADMIN'

*/
