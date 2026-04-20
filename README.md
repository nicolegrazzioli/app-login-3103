Proposta de Projeto: Gestor de Gastos Multimoedas
Nome: pila.go
testar: `flutter run -d chrome`

1. Descrição do Projeto

Assistente financeiro mobile (Flutter + Java), focado em viajantes e intercambistas. O diferencial do app é a organização por "Pastas de Viagem" e a gestão inteligente de Custo Médio (VET). Ele permite que o usuário registre gastos em moeda estrangeira e visualize instantaneamente o impacto real em sua moeda nativa (BRL), baseando-se no valor efetivo pago na compra da moeda.

2. Público-Alvo

   ●​ Estudantes em intercâmbio
   ●​ Viajantes independentes e mochileiros.
   ●​ Nômades digitais que recebem ou gastam em diferentes moedas.

3. Funcionalidades Principais (MVP)

   - Gestão de Viagens: Criação de pastas para separar gastos de diferentes destinos.
   - Gestão de Saldo Global (Carteira): Registro de aportes (compra de moeda) com cálculo automático de VET Médio.
   - Registro de Despesas Contextual: Entrada de gastos com conversão automática baseada no custo médio da "pasta".
   - Categorização Especializada: Alimentação, Mercado, Transporte, Hospedagem, Lazer, Compras, Burocracia e Saúde.
   - Pesquisa e Filtros: Busca contextual de gastos por título, categoria ou data dentro de cada viagem.Persistência Local: Armazenamento robusto para uso offline durante deslocamentos.

5. Arquitetura e Tecnologias

   ●​ Frontend: Flutter (Android/iOS) com gerenciamento de estado e
      armazenamento local (Sqflite).
   ●​ Backend: Java 17+ com Spring Boot, Spring Security e Hibernate.
   ●​ Banco de Dados: PostgreSQL (Relacional) para garantir a consistência dos
      dados financeiros.
   ●​ Segurança: Protocolo HTTPS, autenticação via Token JWT e criptografia de
      dados sensíveis em repouso.

6. Design e cores 

a. background - azul marinho profundo (0F172A)

b. texto - off white (F5F5F5)

c. botão de sucesso - verde sólido (058E64)

d. dinheiro - verde esmeralda (10B981)
   d1. dólar - verde dinheiro (85BB65)
   d2. euro - amarelo dourado (FFD700)

e. contornos - cinza (475569)

f. adicionar - verde neon (00E676)


7. Fontes
- Plus Jakarta Sans - títulos
- Inter - corpo de texto


rodar no celular
Pegue o cabo USB e conecte seu celular no computador.
No seu celular, vá em Configurações > Sobre o Telefone e toque 7 vezes seguidas em "Número da Versão" (ou "Build Number") para ativar o modo desenvolvedor.
Volte nas configurações, vá em Opções de Desenvolvedor e ative a Depuração USB (USB Debugging).
Seu celular vai pedir permissão na tela, clique em "Permitir".
Pronto! Agora volte no seu terminal do PC e rode flutter run. Seu próprio aparelho vai aparecer na lista e o app vai abrir na palma da sua mão!
