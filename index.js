const sql = require('mssql');

// Configurações de conexão
const config = {
    user: 'sa', // Usuário padrão do SQL Server
    password: 'SenhaForte123!', // A mesma senha que você colocou no docker-compose
    server: 'localhost', // Se estiver rodando o Node fora do container
    database: 'master', // O banco padrão inicial. Depois você pode criar o seu.
    options: {
        encrypt: false, // Para Docker local, costuma-se deixar false
        trustServerCertificate: true // Essencial para aceitar o certificado auto-assinado do Docker
    },
    port: 1433
};

async function insertData() {
    try {
        // 1. Abrir a conexão
        let pool = await sql.connect(config);

        // 2. Executar a query com parâmetros
        const nome = "Cadeira Gamer";
        const preco = 1200.50;

        const result = await pool.request()
            .input('nomeParam', sql.VarChar, nome)
            .input('precoParam', sql.Decimal(10, 2), preco)
            .query('INSERT INTO Produtos (Nome, Preco) VALUES (@nomeParam, @precoParam)');

        console.log('Linhas afetadas:', result.rowsAffected);
        
    } catch (err) {
        console.error('Erro ao inserir dados:', err);
    } finally {
        // 3. Fechar a conexão
        await sql.close();
    }
}

insertData();