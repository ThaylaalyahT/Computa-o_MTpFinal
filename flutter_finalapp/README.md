# Flutter Proposta TP Final

## Descrição

Esta aplicação permite aos alunos enviar as suas tarefas e receber feedbacks dos professores, com funcionalidades de login via OAuth2, envio de tarefas (upload ou câmera), visualização de feedbacks e avaliação por parte dos professores, o sistema irá permitir a consulta de tarefas enviadas e os feedbacks já avaliados.

## Funcionalidades

### **1. Aluno**

#### **Ecrã de Login**
- Faz login via OAuth2
- Após o login, o aluno é redirecionado para a **Ecrã Principal**.

#### **Ecrã Principal (Dashboard)**
- Exibe uma lista dos **próximos trabalhos** com data de entrega, nome do trabalho e outros detalhes.
- **Botão de Navegação** para enviar tarefas.
- **Botão de Navegação** para visualizar os feedbacks dos professores.

#### **Ecrã de Submissão de Tarefas**
- Escolhe uma tarefa da lista e envia seu trabalho (upload de ficheiro ou tirando uma foto com a câmera).
- Após o envio, o aluno é redirecionado de volta para a **Ecrã Principal**.

#### **Ecrã de Feedbacks**
- Visualiza os **feedbacks** recebidos dos professores, com notas e comentários.
- Pode consultar o histórico de feedbacks para revisar suas avaliações anteriores.

### **2. Professor**

#### **Ecrã de Login**
- O professor faz login via OAuth2.
- Após o login, o professor é redirecionado para a **Ecrã de Avaliação**.

#### **Ecrã de Avaliação (Dashboard do Professor)**
- Exibe uma lista de **tarefas enviadas pelos alunos** para avaliação.
- A lista contém o **nome do aluno**, **título da tarefa** e **data de envio**.
- Pode clicar em uma tarefa para ver detalhes e avaliar.

#### **Ecrã de Avaliação da Tarefa**
- Visualiza a tarefa enviada pelo aluno (ficheiro ou foto).
- Deixa um **feedback escrito** e uma **nota** para o aluno.
- O feedback e a nota são salvos no base de dados.

#### **Ecrã de Feedbacks**
- O professor consulta as tarefas já avaliadas, visualizando as notas e comentários dados aos alunos.

## Fluxo Completo Simplificado

### **Aluno**
1. **Login**: Aluno entra no app.
2. **Ecrã Principal**: Vê os próximos trabalhos e testes.
3. **Submissão de Tarefa**: Envia suas tarefas.
4. **Feedbacks**: Vê as notas e comentários dos professores.

### **Professor**
1. **Login**: Professor entra no app.
2. **Ecrã de Avaliação**: Vê as tarefas enviadas pelos alunos.
3. **Avaliação da Tarefa**: O professor avalia a tarefa e fornece feedback.
4. **Feedbacks**: O professor consulta as avaliações feitas.

## Funcionalidades Técnicas

- **Login OAuth2**: Implementado com **Firebase Authentication**, permitindo login via **Google**, **Facebook**, ou outros.
- **Submissão de Tarefas**: O aluno faz o upload de ficheiros ao tirar fotos diretamente pelo app utilizando a **câmera** do dispositivo.
- **Feedbacks**: O professor pode deixar feedbacks escritos e atribuir notas aos alunos. O feedback é armazenado na base de dados (**Firebase Firestore**).
- **Dashboard**: O aluno e o professor têm dashboards dedicados que mostram tarefas e feedbacks.

## Tecnologias Utilizadas

- **Flutter**: Para desenvolvimento da aplicação.
- **Firebase Authentication**: Para o sistema de login OAuth2.
- **Firebase Firestore**: Para armazenamento de dados de tarefas, feedbacks e informações dos utilizadores.
- **Firebase Storage**: Para armazenar ficheiros enviados pelos alunos (imagens, PDFs, etc.).
- **Flutter Camera**: Para tirar fotos diretamente do app.