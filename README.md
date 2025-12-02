# Mini Cadastro de Tarefas Profissionais

## Descrição

Este é um aplicativo para gerenciamento de tarefas profissionais, desenvolvido como parte da Prova Prática de Flutter. O app implementa um CRUD (Criar, Ler, Atualizar, Excluir) completo, utilizando o pacote `sqflite` para o armazenamento local das tarefas. As funcionalidades incluem a criação de novas tarefas com título, descrição, prioridade e departamento; a listagem de todas as tarefas; e a capacidade de editar ou excluir tarefas existentes. O visual foi personalizado com o tema "temaTechBlue".

## Dados do Aluno

* **Nome:** Alex Zulini Venier
* **RA:** 202310290

## Campo Personalizado

* **Campo Extra:** departamento
* **Tema:** temaTechBlue
* **Cor Primaria:** indigo
* **Cor Secundaria:** blueAccent

## Dificuldades Encontradas

A principal dificuldade inicial foi a correta organização da estrutura de pastas do projeto, separando a lógica de banco de dados (`db_helper`) da interface do usuário (telas). Outro desafio foi a gestão de estado de forma simples, garantindo que a tela principal fosse atualizada automaticamente após qualquer alteração no banco de dados. Isso foi solucionado passando um valor de retorno através do `Navigator.pop` para indicar a necessidade de recarregar os dados da lista.
