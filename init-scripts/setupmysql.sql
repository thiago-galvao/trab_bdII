-- ============================================================
-- 1. ESTRUTURA DO BANCO
-- ============================================================

-- Criar o banco de dados
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SistemaVendas')
BEGIN
    CREATE DATABASE SistemaVendas;
END
GO

-- Usar o banco de dados
USE SistemaVendas;
GO

-- Tabela 1: Categorias
CREATE TABLE Categorias (
    id_categoria  INT           IDENTITY(1,1) PRIMARY KEY,
    nome          VARCHAR(100)  NOT NULL,
    descricao     VARCHAR(255)  NULL
);
GO

-- Tabela 2: Fornecedores
CREATE TABLE Fornecedores (
    id_fornecedor INT           IDENTITY(1,1) PRIMARY KEY,
    razao_social  VARCHAR(150)  NOT NULL,
    cnpj          CHAR(18)      NOT NULL UNIQUE,
    telefone      VARCHAR(20)   NULL,
    cidade        VARCHAR(100)  NULL,
    estado        CHAR(2)       NULL
);
GO

-- Tabela 3: Produtos
CREATE TABLE Produtos (
    id_produto     INT             IDENTITY(1,1) PRIMARY KEY,
    nome           VARCHAR(150)    NOT NULL,
    preco_unitario DECIMAL(10,2)   NOT NULL,
    estoque        INT             NOT NULL DEFAULT 0,
    id_categoria   INT             NOT NULL,
    id_fornecedor  INT             NOT NULL,
    CONSTRAINT FK_Produto_Categoria  FOREIGN KEY (id_categoria)  REFERENCES Categorias(id_categoria),
    CONSTRAINT FK_Produto_Fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor)
);
GO

-- Tabela 4: Clientes
CREATE TABLE Clientes (
    id_cliente  INT           IDENTITY(1,1) PRIMARY KEY,
    nome        VARCHAR(150)  NOT NULL,
    cpf         CHAR(14)      NOT NULL UNIQUE,
    email       VARCHAR(150)  NULL,
    telefone    VARCHAR(20)   NULL,
    cidade      VARCHAR(100)  NULL,
    estado      CHAR(2)       NULL
);
GO

-- Tabela 5: Pedidos
CREATE TABLE Pedidos (
    id_pedido    INT           IDENTITY(1,1) PRIMARY KEY,
    id_cliente   INT           NOT NULL,
    data_pedido  DATETIME      NOT NULL DEFAULT GETDATE(),
    status       VARCHAR(20)   NOT NULL DEFAULT 'Pendente'
                               CHECK (status IN ('Pendente','Aprovado','Cancelado','Entregue')),
    total        DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
GO

-- Tabela 6: ItensPedido
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE ItensPedido (
    id_item        INT            IDENTITY(1,1) PRIMARY KEY,
    id_pedido      INT            NOT NULL,
    id_produto     INT            NOT NULL,
    quantidade     INT            NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2)  NOT NULL,
    subtotal       AS (quantidade * preco_unitario),
    CONSTRAINT FK_Item_Pedido   FOREIGN KEY (id_pedido)  REFERENCES Pedidos(id_pedido),
    CONSTRAINT FK_Item_Produto  FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);
GO

-- ============================================================
-- 2. CARGA DE DADOS
-- ============================================================

INSERT INTO Categorias (nome, descricao) VALUES
('Eletrônicos', 'Smartphones, tablets, acessórios tech'),
('Informática', 'Notebooks, periféricos e componentes'),
('Games', 'Consoles, jogos e acessórios gamer'),
('Eletrodomésticos', 'Geladeiras, fogões, micro-ondas'),
('Moda', 'Roupas, calçados e acessórios'),
('Livros', 'Ficção, técnicos, didáticos'),
('Esportes', 'Equipamentos e roupas esportivas'),
('Beleza', 'Cosméticos, perfumes e cuidados pessoais'),
('Ferramentas', 'Ferramentas elétricas e manuais'),
('Alimentos', 'Produtos alimentícios e bebidas');
GO

INSERT INTO Fornecedores (razao_social, cnpj, telefone, cidade, estado) VALUES
('TechDistrib Ltda', '11.222.333/0001-44', '(11) 3000-1000', 'Sao Paulo', 'SP'),
('MegaInfo Comercio', '22.333.444/0001-55', '(21) 3100-2000', 'Rio de Janeiro', 'RJ'),
('Games Sul Distribuidora', '33.444.555/0001-66', '(41) 3200-3000', 'Curitiba', 'PR'),
('EletroMax S/A', '44.555.666/0001-77', '(31) 3300-4000', 'Belo Horizonte', 'MG'),
('FashionBR Ind. Com.', '55.666.777/0001-88', '(85) 3400-5000', 'Fortaleza', 'CE'),
('Livraria Central Ltda', '66.777.888/0001-99', '(51) 3500-6000', 'Porto Alegre', 'RS'),
('SportLife Atacado', '77.888.999/0001-00', '(62) 3600-7000', 'Goiania', 'GO'),
('BeautyCo Importacoes', '88.999.000/0001-11', '(71) 3700-8000', 'Salvador', 'BA'),
('FerraTool Industria', '99.000.111/0001-22', '(91) 3800-9000', 'Belem', 'PA'),
('AlimFresh Distribuidora', '10.111.222/0001-33', '(48) 3900-0000', 'Florianopolis', 'SC');
GO

INSERT INTO Produtos (nome, preco_unitario, estoque, id_categoria, id_fornecedor) VALUES
('Smartphone Galaxy A54', 1899.90, 50, 1, 1),
('Notebook Lenovo IdeaPad 3', 3299.00, 30, 2, 2),
('Console PlayStation 5', 4499.00, 15, 3, 3),
('Micro-ondas Consul 30L', 699.90, 40, 4, 4),
('Camiseta Casual Masculina', 59.90, 200, 5, 5),
('Clean Code Robert C. Martin', 109.90, 100, 6, 6),
('Tenis de Corrida Nike Air', 399.90, 80, 7, 7),
('Perfume Importado 100ml', 249.90, 60, 8, 8),
('Furadeira DeWalt 20V', 689.90, 25, 9, 9),
('Whey Protein 2kg', 189.90, 90, 10, 10),
('Mouse Gamer Rapoo VT7 Max', 349.90, 70, 3, 1),
('Teclado Mecanico Redragon', 299.90, 55, 2, 2);
GO

INSERT INTO Clientes (nome, cpf, email, telefone, cidade, estado) VALUES
('Ana Paula Ferreira', '111.222.333-44', 'ana.paula@email.com', '(41) 99001-1111', 'Curitiba', 'PR'),
('Bruno Oliveira', '222.333.444-55', 'bruno.oli@email.com', '(11) 99002-2222', 'Sao Paulo', 'SP'),
('Carla Mendes', '333.444.555-66', 'carla.m@email.com', '(21) 99003-3333', 'Rio de Janeiro', 'RJ'),
('Diego Costa', '444.555.666-77', 'diego.c@email.com', '(31) 99004-4444', 'Belo Horizonte', 'MG'),
('Fernanda Lima', '555.666.777-88', 'fer.lima@email.com', '(48) 99005-5555', 'Florianopolis', 'SC'),
('Gabriel Souza', '666.777.888-99', 'gabriel.s@email.com', '(51) 99006-6666', 'Porto Alegre', 'RS'),
('Helena Rodrigues', '777.888.999-00', 'helena.r@email.com', '(62) 99007-7777', 'Goiania', 'GO'),
('Igor Martins', '888.999.000-11', 'igor.m@email.com', '(85) 99008-8888', 'Fortaleza', 'CE'),
('Juliana Alves', '999.000.111-22', 'ju.alves@email.com', '(91) 99009-9999', 'Belem', 'PA'),
('Lucas Pereira', '010.111.222-33', 'lucas.p@email.com', '(71) 99010-0000', 'Salvador', 'BA'),
('Mariana Santos', '020.222.333-44', 'mari.santos@email.com', '(41) 99011-1111', 'Curitiba', 'PR'),
('Nicolas Gomes', '030.333.444-55', 'nico.g@email.com', '(41) 99012-2222', 'Curitiba', 'PR');
GO

INSERT INTO Pedidos (id_cliente, data_pedido, status, total) VALUES
(1, '2025-01-05 10:00:00', 'Entregue', 0),
(2, '2025-01-10 11:30:00', 'Entregue', 0),
(3, '2025-01-15 09:00:00', 'Entregue', 0),
(4, '2025-02-01 14:00:00', 'Aprovado', 0),
(5, '2025-02-10 15:00:00', 'Aprovado', 0),
(6, '2025-02-20 16:00:00', 'Pendente', 0),
(7, '2025-03-01 08:00:00', 'Cancelado', 0),
(8, '2025-03-10 10:30:00', 'Entregue', 0),
(9, '2025-03-15 13:00:00', 'Aprovado', 0),
(10, '2025-03-20 09:30:00', 'Pendente', 0),
(11, '2025-04-01 11:00:00', 'Aprovado', 0),
(12, '2025-04-05 14:30:00', 'Pendente', 0);
GO

INSERT INTO ItensPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1899.90),
(2, 2, 1, 3299.00),
(3, 3, 1, 4499.00),
(4, 4, 1, 699.90),
(5, 7, 1, 399.90),
(6, 6, 2, 109.90),
(6, 11, 1, 349.90),
(7, 10, 1, 189.90),
(8, 9, 1, 689.90),
(9, 8, 1, 249.90),
(10, 5, 2, 59.90),
(10, 10, 1, 189.90),
(11, 11, 1, 349.90),
(12, 2, 1, 3299.00),
(12, 12, 1, 299.90);
GO

-- ============================================================
-- 3. OBJETOS PROGRAMÁVEIS (VIEWS, FUNCTIONS, PROCEDURES)
-- ============================================================

CREATE VIEW vw_PedidosDetalhados AS
SELECT
    p.id_pedido,
    c.nome            AS cliente,
    p.data_pedido,
    p.status,
    pr.nome           AS produto,
    i.quantidade,
    i.preco_unitario,
    i.subtotal,
    p.total           AS total_pedido
FROM Pedidos p
JOIN Clientes    c  ON c.id_cliente  = p.id_cliente
JOIN ItensPedido i  ON i.id_pedido   = p.id_pedido
JOIN Produtos    pr ON pr.id_produto = i.id_produto;
GO

CREATE FUNCTION dbo.fn_TotalGastoPorCliente(@id_cliente INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2)
    SELECT @total = SUM(total)
    FROM Pedidos
    WHERE id_cliente = @id_cliente
    AND status != 'Cancelado'
    RETURN ISNULL(@total, 0)
END
GO

CREATE PROCEDURE sp_PedidosPorCliente
    @id_cliente INT
AS
BEGIN
    SET NOCOUNT ON
    SELECT nome, email, cidade, estado FROM Clientes WHERE id_cliente = @id_cliente
    SELECT
        p.id_pedido, p.data_pedido, p.status, pr.nome AS produto,
        i.quantidade, i.preco_unitario, i.subtotal, p.total AS total_pedido
    FROM Pedidos p
    JOIN ItensPedido i  ON i.id_pedido   = p.id_pedido
    JOIN Produtos    pr ON pr.id_produto = i.id_produto
    WHERE p.id_cliente = @id_cliente
    ORDER BY p.data_pedido DESC
END
GO

CREATE TRIGGER trg_AtualizaTotalPedido
ON ItensPedido
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON
    UPDATE Pedidos
    SET total = (
        SELECT ISNULL(SUM(quantidade * preco_unitario), 0)
        FROM ItensPedido
        WHERE ItensPedido.id_pedido = Pedidos.id_pedido
    )
    WHERE id_pedido IN (SELECT id_pedido FROM inserted UNION SELECT id_pedido FROM deleted)
END
GO

-- Atualização inicial dos totais
UPDATE Pedidos SET total = (
    SELECT ISNULL(SUM(quantidade * preco_unitario), 0)
    FROM ItensPedido WHERE ItensPedido.id_pedido = Pedidos.id_pedido
)
GO

-- ============================================================
-- 4. TRANSAÇÕES E TESTES
-- ============================================================

BEGIN TRANSACTION
BEGIN TRY
    INSERT INTO Pedidos (id_cliente, data_pedido, status, total)
    VALUES (2, GETDATE(), 'Pendente', 0)
    DECLARE @novo_pedido INT = SCOPE_IDENTITY()
    INSERT INTO ItensPedido (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES (@novo_pedido, 11, 1, 349.90), (@novo_pedido, 12, 1, 299.90)
    COMMIT TRANSACTION
    PRINT 'Pedido ' + CAST(@novo_pedido AS VARCHAR) + ' inserido com sucesso!'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Erro: ' + ERROR_MESSAGE()
END CATCH
GO

-- Tabela Temporária
CREATE TABLE #ResumoVendas (
    cliente VARCHAR(150), qtd_pedidos INT, valor_total DECIMAL(10,2), ticket_medio DECIMAL(10,2)
)
GO
INSERT INTO #ResumoVendas
SELECT c.nome, COUNT(p.id_pedido), SUM(p.total), AVG(p.total)
FROM Clientes c JOIN Pedidos p ON p.id_cliente = c.id_cliente
WHERE p.status != 'Cancelado' GROUP BY c.nome
GO
SELECT * FROM #ResumoVendas ORDER BY valor_total DESC;
DROP TABLE #ResumoVendas;
GO

-- Cursor de Alerta (Sem GO entre declaração e uso)
DECLARE @nome_produto VARCHAR(150), @estoque INT, @alerta VARCHAR(300)
DECLARE cur_EstoqueBaixo CURSOR FOR SELECT nome, estoque FROM Produtos WHERE estoque < 30
OPEN cur_EstoqueBaixo
FETCH NEXT FROM cur_EstoqueBaixo INTO @nome_produto, @estoque
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @alerta = 'ALERTA: "' + @nome_produto + '" - apenas ' + CAST(@estoque AS VARCHAR) + ' unidade(s).'
    PRINT @alerta
    FETCH NEXT FROM cur_EstoqueBaixo INTO @nome_produto, @estoque
END
CLOSE cur_EstoqueBaixo
DEALLOCATE cur_EstoqueBaixo
GO

-- Log com Output
CREATE TABLE LogPedidos (id_pedido INT, data_pedido DATETIME, status VARCHAR(20))
GO
INSERT INTO Pedidos (id_cliente, data_pedido, status, total)
OUTPUT inserted.id_pedido, inserted.data_pedido, inserted.status INTO LogPedidos
VALUES (3, GETDATE(), 'Pendente', 0)
GO
SELECT * FROM LogPedidos;
GO