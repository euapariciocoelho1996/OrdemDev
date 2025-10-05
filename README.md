# OrdemDev

Aplicativo mobile para estudo prático de Algoritmos de Ordenação e fundamentos de programação, com quizzes, desafios e visualizações interativas.

---

## 1. Documentação do aplicativo

### 1.1. Introdução / Visão geral
- **Nome do app**: OrdemDev
- **Objetivo**: Tornar o estudo de algoritmos e fundamentos de programação mais envolvente por meio de quizzes, desafios e visualizações didáticas (Foco em algoritmos de ordenação).
- **Público-alvo**: Estudantes de programação e áreas relacionadas.
- **Plataformas suportadas**: Android (mínimo Android 6.0 – API 23).
- **Tecnologias usadas**: Flutter, Dart, cupertino_icons, google_fonts, flutter_svg, animated_text_kit, flutter_animate, shared_preferences, audioplayers, confetti, flutter_highlight, firebase_core, firebase_auth, cloud_firestore, google_sign_in, image_picker, image_cropper, crop_your_image, firebase_storage, url_launcher, connectivity_plus, http, vibration, flutter_staggered_animations, flutter_lints (dev), flutter_launcher_icons (dev).

### 1.2. Funcionalidades principais
- **Onboarding e Login**
  - Autenticação por e-mail/senha (Firebase Auth) e recuperação de senha.
  - Onboarding inicial com apresentação do app.
- **Tela Inicial e Navegação**
  - Home com seções de boas-vindas, guia de estudos, desafios, ranking e referências.
  - Navegação por `Navigator`/rotas (arquivo `lib/routes.dart`) e bottom navigation (`lib/navigation`).
- **Conceitos de Introdução**
  - Telas didáticas de conceitos iniciais: variáveis, tipos de dados, operadores, funções, entrada/saída, estruturas de repetição, condicionais, vetores e ponteiros.
- **Algoritmos de Ordenação**
  - Telas dedicadas para Bubble, Selection, Insertion, Quick, Merge e Heap Sort, com explicações e interações.
- **Quizzes e Desafios**
  - Níveis e tarefas de quiz (introdução e ordenação).
  - Desafios variados (ex.: combo com risco, aleatório, acerto ou perda).
  - Progresso do usuário salvo localmente e no Firestore.
- **Comentários da Comunidade**
  - Publicação e leitura de comentários, respostas, curtidas (coleção `comentarios`).
- **Perfil**
  - Exibição do progresso do usuário dentro do app (pontos, níveis concluídos, histórico de atividades quando aplicável).
- **Trilha e Pontuação**
  - Registro de progresso e pontos do usuário em `user_progress` e `user_points`.

### 1.3. Arquitetura e tecnologia
- **Estrutura de pastas**
  - `lib/`
    - `main.dart`: inicialização do app.
    - `routes.dart`: definição de rotas nomeadas.
    - `Telas/`: telas organizadas por seções (ex.: `Inicio/`, `conceitos-introducao/`, `conceitos-ordenacao/`, `jogo-introducao/`, `desafios/`, etc.).
    - `navigation/`: scaffolds, bottom navigation e navegação.
    - `services/`: serviços de domínio (ex.: progresso, áudio, música de fundo, quiz progress).
    - `models/`: modelos de dados para quizzes, conquistas e conteúdo.
    - `widgets/`: componentes reutilizáveis de UI (ex.: banners, botões, efeitos, visualizações).
    - `appBar/`, `Header/`, `Cores/`, `body/`: componentes estruturais/estéticos.
    - `firebase/firebase_options.dart`: opções do Firebase (gerado pelo FlutterFire CLI).
  - `assets/`
    - `All_Itens/`: imagens e áudios utilizados nas telas e efeitos.
  - `android/`: projeto Android nativo e `google-services.json` do Firebase.

- **Padrão arquitetural**
  - Estrutura modular por telas/serviços/widgets. Estado local por widget e serviços específicos para persistência e integração (ex.: `ProgressService`, `QuizProgressService`, `ProfilePhotoService`).
  - Pode evoluir para padrões como Provider/BLoC/MVVM conforme a necessidade de estado global.

- **Bibliotecas e plugins principais** (ver versões em `pubspec.yaml`)
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
  - `google_fonts`, `flutter_svg`, `flutter_animate`, `confetti`
  - `shared_preferences`, `audioplayers`, `image_picker`, `image_cropper`, `connectivity_plus`, `url_launcher`, `http`, `vibration`

- **Fluxo de dados**
  - Autenticação: Firebase Auth (e-mail/senha).
  - Persistência: progresso e pontos no Firestore; preferências locais com `SharedPreferences`.
  - Leitura em tempo real de comentários via streams do Firestore.

- **Integração com backend (Firebase)**
  - Firestore como banco de dados de documentos.
  - Storage para arquivos de imagem de perfil.
  - Regras de segurança controlam acesso por usuário e coleção.

### 1.4. Fluxo de navegação
- As rotas principais estão mapeadas em `lib/routes.dart` (ex.: `/`, `/quiz-levels`, `/study-guide`, `/challenge-hub`, etc.).
- O fluxo geral: Onboarding/Login → Home → (Conceitos | Algoritmos | Quizzes | Desafios | Comentários | Perfil).
- Sugestão para documentação: adicionar um diagrama simples (ex.: em `docs/navigation.png`) indicando as transições entre telas.

### 1.5. Guia de instalação / execução
1. **Pré-requisitos**
   - Flutter SDK (compatível com Dart `sdk: ^3.6.2` conforme `pubspec.yaml`).
   - Android Studio/SDK ou VS Code + extensões do Flutter.
2. **Clonar o projeto**
   - `git clone <URL_DO_REPOSITORIO>`
   - `cd app_tcc_nova_versao`
3. **Instalar dependências**
   - `flutter pub get`
4. **Executar**
   - Emulador Android ou dispositivo físico via `flutter run`.
5. **Build**
   - Debug APK: `flutter build apk --debug`
   - Release APK: `flutter build apk --release`

### 1.7. Screenshots e demonstrações
<p>Telas de Onboarding.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/on1.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/on2.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/on3.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/on4.jpg" width="150" />
</p>


<p>Telas de Login / Criação de Conta / Home.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/login.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/criar-conta.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/home.jpg" width="200" />
</p>

<p>Telas de Conteúdo Introdutório + Tela de conteúdo principal (Algoritmos de Ordenação).</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/introducao.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/conteudo-introducao.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/conteudo-ord.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/conteudo-orde-estudo.jpg" width="150" />
</p>
<p>Telas de Níveis de introdução / Níveis principais com pontuação / Quizz.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/niveis-introducao.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/niveis-orde-pontos.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/quizz.jpg" width="200" />
</p>
<p>Telas de Feedback.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/feedback-acerto.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/feedback-erro.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/feedback-sem-vidas.jpg" width="150" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/nivel-completo.jpg" width="150" />
</p>

<p>Telas de novos desafios / Ranking / Sessão de comentários.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/desafios.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/ranking.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/comentarios.jpg" width="200" />
</p>
<p>Telas de Guia de estudos / Tela de referências. </p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/guia.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/ref.jpg" width="200" />
</p>
<p>Telas de avisos caso o usuário esteja sem internet / Perfil do usuário.</p>
<p float="left">
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/informando-net.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/sem-internet.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/sem-internet-2.jpg" width="200" />
  <img src="https://raw.githubusercontent.com/euapariciocoelho1996/OrdemDev/main/lib/OrdemDev-prints/OrdemDev/perfil.jpeg" width="200" />
</p>







### 1.8. Observações técnicas e decisões
- **Segurança Firebase (recomendado)**
  - Garanta que as regras não estejam abertas globalmente.
  - Defina políticas de leitura e escrita por usuário para coleções como `user_progress`, `user_points` e `user_profiles`, e modelagem adequada para `comentarios`.

- **Decisões**
  - Uso de Firebase para autenticação, persistência e mídia por simplicidade de integração.
  - Serviços dedicados para progresso e pontos para separar responsabilidades.
  - Widgets reutilizáveis para efeitos visuais e UX consistentes.

### 1.9. Referências / Créditos
- Bibliotecas: ver lista em `pubspec.yaml`.
- Documentação Flutter: https://docs.flutter.dev
- Firebase: https://firebase.google.com/docs
- Ícones/recursos visuais conforme licenças aplicáveis.

---

