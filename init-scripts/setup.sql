-- Criar o banco de dados
CREATE DATABASE MinhaBaseDeDados;
GO

-- Usar o banco de dados
USE MinhaBaseDeDados;
GO

-- Criar a tabela
CREATE TABLE Usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255)
);
GO
