
---

# PaLevá App

## Descrição

O **PaLevá App** é um sistema de gestão para restaurantes que funcionam na modalidade "take-out" (ou em português, PaLevá). O sistema foi desenvolvido em **Ruby on Rails** e tem dois modos principais:

1. **Painel Administrativo para Donos de Restaurante**: Permite aos donos de restaurante gerenciar horários de funcionamento, pedidos, bebidas, pratos, cardápios, descontos, pré-cadastrar funcionários e administrar os pedidos feitos.
   
2. **API para o App de Cozinha**: Serve como backend para um aplicativo de cozinha feito em **Vue.js**, que consome dados dos pedidos e altera os status de pedidos em tempo real.

### Funcionalidades
- **Donos de Restaurante**:
  - Gerenciar horários de funcionamento.
  - Controlar cardápios, bebidas e pratos.
  - Administrar pedidos.
  - Realizar pré-cadastro de funcionários.
  - Administrar Descontos
  
- **Funcionários**:
  - Visualizar cardápios.
  - Adicionar itens de cardápio aos pedidos.
  - Consultar os horários de funcionamento.
  
- **API para Cozinha**:
  - Envio de dados dos pedidos realizados.
  - Alterar status de pedidos ("em preparação", "pronto", "entregue", e "cancelado").

---

## Tecnologias Usadas

-   **Ruby on Rails 7.2.1**
-   **SQLite3** (para banco de dados em desenvolvimento)
-   **RSpec** e **Capybara** para testes
-   **Devise** para autenticação de usuários
-   **Rack-CORS** para permitir requisições Cross-Origin
-   **TailwindCSS** para estilização
-   **Jbuilder** para construção de respostas JSON na API
-   **cpf_cnpj** para validação de documentos

---

## Instruções de Uso

Siga os passos abaixo para rodar o projeto localmente:

1. **Clone o repositório**:

    ```bash
    git clone https://github.com/rmoreno-w/paleva-app
    cd paleva-app
    ```

2. **Instale as dependências do projeto**:

    ```bash
    bundle install
    ```

3. **Crie o banco de dados**:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. **Inicie o servidor**:

    ```bash
    rails server
    ```

5. Abra seu navegador e acesse `http://localhost:3000` para ver o aplicativo em funcionamento.

---

## Uso

### Para Donos de Restaurante:

-   Realize o login com a conta de administrador criada.
-   Você poderá acessar o painel para gerenciar horários de funcionamento, cardápios, bebidas, pratos e pedidos.

### Para Funcionários:

-   Realize o pré-cadastro para se associar ao restaurante.
-   Após login, os funcionários poderão visualizar cardápios, fazer pedidos e verificar horários de funcionamento.

### Para o App de Cozinha:

O backend deste projeto é utilizado para fornecer dados para o aplicativo de cozinha feito em **Vue.js**. Para usar o aplicativo Vue.js, acesse o [Repositório](https://github.com/rmoreno-w/paleva-kitchen-app).

---

## Testes

O projeto contém testes unitários e de sistema utilizando **RSpec** e **Capybara**:

-   **Testes de Model**: Para validar o comportamento dos modelos e associações.
-   **Testes de Sistema**: Para testar fluxos completos, como login e criação de pedidos.
-   **Testes de Requisições**: Para garantir que as APIs estejam funcionando corretamente.

Para rodar os testes, use o comando:

```bash
rspec
```

---

## Links Úteis

-   Para estilização do projeto, utilizei como base um **Style Guide** que montei para construir meu site de Portfólio. O **Style Guide** está disponível neste [Link do Figma](https://www.figma.com/design/fcekS1ez7POz6eaLrQIMHT/Site-Portfolio?t=JQd0cE7vAhFKCoGN-0)
-   **Diagrama do Banco de Dados**: Diagrama que ilustra os Modelos utilizados e suas ligações, feito no Excalidraw. Pode ser visto na imagem abaixo, ou no [link de Diagrama das Models](https://github.com/rmoreno-w/paleva-app/blob/main/app/assets/images/paleva_database_schema.png)
<img alt="Database Schema" src="https://raw.githubusercontent.com/rmoreno-w/paleva-app/refs/heads/main/app/assets/images/paleva_database_schema.png" />

---
