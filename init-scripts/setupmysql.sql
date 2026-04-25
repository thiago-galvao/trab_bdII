-- ============================================================
-- 1. ESTRUTURA DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS meu_banco;
USE meu_banco;

-- Tabela 1: Categorias
CREATE TABLE Categorias (
    id_categoria  INT           AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100)  NOT NULL,
    descricao     VARCHAR(255)  NULL
) ENGINE=InnoDB;

-- Tabela 2: Fornecedores
CREATE TABLE Fornecedores (
    id_fornecedor INT           AUTO_INCREMENT PRIMARY KEY,
    razao_social  VARCHAR(150)  NOT NULL,
    cnpj          CHAR(18)      NOT NULL UNIQUE,
    telefone      VARCHAR(20)   NULL,
    cidade        VARCHAR(100)  NULL,
    estado        CHAR(2)       NULL
) ENGINE=InnoDB;

-- Tabela 3: Produtos
CREATE TABLE Produtos (
    id_produto     INT             AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(150)    NOT NULL,
    preco_unitario DECIMAL(10,2)   NOT NULL,
    estoque        INT             NOT NULL DEFAULT 0,
    id_categoria   INT             NOT NULL,
    id_fornecedor  INT             NOT NULL,
    CONSTRAINT FK_Produto_Categoria  FOREIGN KEY (id_categoria)  REFERENCES Categorias(id_categoria),
    CONSTRAINT FK_Produto_Fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor)
) ENGINE=InnoDB;

-- Tabela 4: Clientes
CREATE TABLE Clientes (
    id_cliente  INT           AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(150)  NOT NULL,
    cpf         CHAR(14)      NOT NULL UNIQUE,
    email       VARCHAR(150)  NULL,
    telefone    VARCHAR(20)   NULL,
    cidade      VARCHAR(100)  NULL,
    estado      CHAR(2)       NULL
) ENGINE=InnoDB;

-- Tabela 5: Pedidos
CREATE TABLE Pedidos (
    id_pedido    INT           AUTO_INCREMENT PRIMARY KEY,
    id_cliente   INT           NOT NULL,
    data_pedido  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(20)   NOT NULL DEFAULT 'Pendente'
                               CHECK (status IN ('Pendente','Aprovado','Cancelado','Entregue')),
    total        DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
) ENGINE=InnoDB;

-- Tabela 6: ItensPedido
CREATE TABLE ItensPedido (
    id_item        INT            AUTO_INCREMENT PRIMARY KEY,
    id_pedido      INT            NOT NULL,
    id_produto     INT            NOT NULL,
    quantidade     INT            NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2)  NOT NULL,
    subtotal       DECIMAL(10,2)  GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    CONSTRAINT FK_Item_Pedido   FOREIGN KEY (id_pedido)  REFERENCES Pedidos(id_pedido),
    CONSTRAINT FK_Item_Produto  FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
) ENGINE=InnoDB;

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

-- Delimitador necessário para criar Procedures, Triggers e Functions no MySQL
DELIMITER //

CREATE FUNCTION fn_TotalGastoPorCliente(v_id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(total) INTO v_total
    FROM Pedidos
    WHERE id_cliente = v_id_cliente
    AND status != 'Cancelado';
    RETURN IFNULL(v_total, 0);
END //

CREATE PROCEDURE sp_PedidosPorCliente(IN v_id_cliente INT)
BEGIN
    SELECT nome, email, cidade, estado FROM Clientes WHERE id_cliente = v_id_cliente;
    
    SELECT
        p.id_pedido, p.data_pedido, p.status, pr.nome AS produto,
        i.quantidade, i.preco_unitario, i.subtotal, p.total AS total_pedido
    FROM Pedidos p
    JOIN ItensPedido i  ON i.id_pedido   = p.id_pedido
    JOIN Produtos    pr ON pr.id_produto = i.id_produto
    WHERE p.id_cliente = v_id_cliente
    ORDER BY p.data_pedido DESC;
END //

CREATE TRIGGER trg_AtualizaTotalPedido_Insert
AFTER INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (SELECT IFNULL(SUM(quantidade * preco_unitario), 0) FROM ItensPedido WHERE id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END //

CREATE TRIGGER trg_AtualizaTotalPedido_Update
AFTER UPDATE ON ItensPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (SELECT IFNULL(SUM(quantidade * preco_unitario), 0) FROM ItensPedido WHERE id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END //

CREATE TRIGGER trg_AtualizaTotalPedido_Delete
AFTER DELETE ON ItensPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (SELECT IFNULL(SUM(quantidade * preco_unitario), 0) FROM ItensPedido WHERE id_pedido = OLD.id_pedido)
    WHERE id_pedido = OLD.id_pedido;
END //

DELIMITER ;

-- Atualização inicial dos totais
UPDATE Pedidos p SET total = (
    SELECT IFNULL(SUM(quantidade * preco_unitario), 0)
    FROM ItensPedido i WHERE i.id_pedido = p.id_pedido
);