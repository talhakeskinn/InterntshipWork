USE [AdventureWorks2019]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stpProductPagination]
    @SchemaName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @PageNumber INT,
    @PageSize INT,
    @PageCount INT OUTPUT
AS
BEGIN
    DECLARE @TumVeri INT;
    DECLARE @Offset INT;
    DECLARE @TumVeriSql NVARCHAR(MAX);
    DECLARE @Sql NVARCHAR(MAX);
    SET @Offset = (@PageNumber - 1) * @PageSize;
    SET @TumVeriSql = N'SELECT @TumVeri = COUNT(*) FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);
    EXEC sp_executesql @TumVeriSql, N'@TumVeri INT OUTPUT', @TumVeri OUTPUT;
    SET @PageCount = @TumVeri / @PageSize;
    SET @Sql = N'SELECT *
                 FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
                 ORDER BY (SELECT NULL)
                 OFFSET @Offset ROWS
                 FETCH NEXT @PageSize ROWS ONLY';

    EXEC sp_executesql @Sql,
        N'@Offset INT, @PageSize INT',
        @Offset = @Offset,
        @PageSize = @PageSize;
    SELECT @PageCount AS SayfaSayisi;
END;
