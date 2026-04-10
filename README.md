Proposta de Projeto: Gestor de Gastos Multimoedas
Nome: pila.go
testar: `flutter run -d chrome`

1. Descrição do Projeto

Aplicativo mobile desenvolvido em Flutter com backend em Java (Spring Boot),
projetado para auxiliar viajantes e estudantes em intercâmbio no controle de suas
finanças. O diferencial do app é a organização por "Pastas de Viagem" e a
capacidade de lidar com múltiplas moedas simultaneamente, permitindo que o
usuário registre gastos em moeda estrangeira e visualize o impacto real no seu
orçamento em sua moeda nativa (BRL).

2. Público-Alvo

   ●​ Estudantes em intercâmbio
   ●​ Viajantes independentes e mochileiros.
   ●​ Nômades digitais que recebem ou gastam em diferentes moedas.

3. Funcionalidades Principais (MVP)

   ●​ Gestão de Viagens: Criação de pastas específicas para cada destino ou
      período.
   ●​ Registro de Despesas Multimoedas: Entrada de valores em EUR, USD,
      BRL, etc., com conversão automática
   ●​ Categorização Especializada: Divisão de gastos em: Alimentação,
      Deslocamento, Entretenimento, Acomodação, Burocracia (Vistos/Seguros) e
      Compra de Moeda.
   ●​ Histórico Detalhado: Visualização cronológica de todas as transações de
      uma viagem específica.
   ●​ Dashboards de Consumo: Gráficos que mostram onde o dinheiro está
      sendo gasto dentro de cada categoria.

4. Regras de Negócio (RN)

   ●​ RN01 – Autenticação: O acesso aos dados é exclusivo de usuários
      autenticados via JWT. Um usuário não pode visualizar viagens de terceiros.
   ●​ RN02 – Isolamento por Pasta: Toda despesa deve, obrigatoriamente, estar
      vinculada a uma "Viagem" criada previamente.
   ●​ RN03 – Conversão de Moeda: O sistema deve permitir que o usuário defina
      uma taxa de câmbio manual (baseada no que ele pagou na casa de câmbio)
      ou utilize a cotação comercial do dia via API externa.
   ●​ RN04 – Integridade Monetária: Os valores financeiros devem ser
      armazenados no banco de dados como números inteiros (centavos) para
      evitar erros de arredondamento de ponto flutuante.
   ●​ RN05 – Persistência Offline: O app deve permitir o registro de gastos sem
      conexão à internet, sincronizando com o servidor assim que detectar uma
      conexão ativa.

5. Arquitetura e Tecnologias

   ●​ Frontend: Flutter (Android/iOS) com gerenciamento de estado e
      armazenamento local (Sqflite).
   ●​ Backend: Java 17+ com Spring Boot, Spring Security e Hibernate.
   ●​ Banco de Dados: PostgreSQL (Relacional) para garantir a consistência dos
      dados financeiros.
   ●​ Segurança: Protocolo HTTPS, autenticação via Token JWT e criptografia de
      dados sensíveis em repouso.

6. Design e cores (ta errado isso aqui)

a. azul marinho profundo 1 (1A2B48)
<img src="1A2B48.png" width="300" height="150">

b. azul marinho profundo 2 (001E28)
<img src="001E28.png" width="300" height="150">

c. verde brilhante (00E676)
<img src="00E676.png" width="300" height="150">

d. verde escuro (00572C)
<img src="00572C.png" width="300" height="150">

e. branco papel manteiga (F5F5F5)
<img src="F5F5F5.png" width="300" height="150">

f. laranjão (FF8F00)
<img src="FF8F00.png" width="300" height="150">


7. Fontes
- Plus Jakarta Sans - títulos
- Inter - corpo de texto
