# Gerenciamento de Banco de Dados com Docker

Este projeto fornece um ambiente pré-configurado utilizando **Docker Compose** para rodar um servidor **Microsoft SQL Server** junto com o **Adminer** para gerenciamento via interface web.

## Pré-requisitos

Antes de começar, você precisará ter instalado em sua máquina:

* [Docker](https://www.docker.com/get-started) 🐳
* (Opcional) Editor de código de sua preferência (Ex: VS Code, Vim, Nano).

---

## Como Rodar o Programa

1. Abra o terminal na raiz do projeto onde se encontra o arquivo `docker-compose.yml`.
2. Execute o comando abaixo para iniciar os serviços em segundo plano:

```bash
docker-compose up -d
````

3.  Aguarde alguns segundos até que o SQL Server complete a inicialização interna.

-----

## Como Acessar o Banco de Dados

Para gerenciar suas tabelas e dados, utilize a interface do **Adminer**:

1.  Digite na barra de endereços do seu navegador: [http://localhost:8080/](https://www.google.com/search?q=http://localhost:8080/)
2.  Preencha as credenciais de acesso conforme a imagem abaixo:

<p align="center"\>
<img src="https://github.com/user-attachments/assets/64bc10f8-4bf6-46ac-8d91-93c15be4ca18" alt="Configuração de Login Adminer" width="600"\>
</p\>

### Detalhes da Conexão:

| Campo | Valor |
| :--- | :--- |
| **Sistema** | `MS SQL` |
| **Servidor** | `sqlserver` |
| **Usuário** | `sa` |
| **Senha** | `SenhaForte123!` |
| **Banco de dados** | *(Pode deixar em branco inicialmente)* |

-----

## Como Parar os Serviços

Caso precise encerrar a execução dos containers, utilize:

```bash
docker-compose down
```

## Gerenciamento de Memória e Limpeza

O Docker pode ocupar bastante espaço em disco ao longo do tempo. Se você deseja remover completamente os recursos criados por este projeto para liberar espaço, siga os passos abaixo:

**1. Remover Containers e Volumes do Projeto**

Para apagar os containers deste projeto e também o volume de dados (apagando tudo que foi gravado no banco), use:
```bash
docker-compose down -v
```
3. Limpeza Geral (Deep Clean)
Para remover todas as imagens, containers parados e volumes que não estão sendo usados por nenhum container no seu PC:

```Bash
docker system prune -a --volumes
```
Cuidado: O comando acima remove recursos de outros projetos também, não apenas deste!
