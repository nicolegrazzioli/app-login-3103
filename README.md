Proposta de Projeto: Gestor de Gastos Multimoedas
Nome: pila.go
testar no chrome: 
```bash
flutter run -d chrome
```
testar no mobile:
1. Sobre o Telefone 
2. "Número da Versão" (ou "Build Number")
```bash
flutter run
```

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

7. Fontes
- Plus Jakarta Sans - títulos
- Inter - corpo de texto


rodar no celular
Pegue o cabo USB e conecte seu celular no computador.
No seu celular, vá em Configurações > Sobre o Telefone e toque 7 vezes seguidas em "Número da Versão" (ou "Build Number") para ativar o modo desenvolvedor.
Volte nas configurações, vá em Opções de Desenvolvedor e ative a Depuração USB (USB Debugging).
Seu celular vai pedir permissão na tela, clique em "Permitir".
Pronto! Agora volte no seu terminal do PC e rode flutter run. Seu próprio aparelho vai aparecer na lista e o app vai abrir na palma da sua mão!
