# Documento de Arquitetura e Especificações Técnicas - Projeto NAAFAG

## 1. Introdução

**Este documento consolida as decisões de arquitetura, stack tecnológica e modelagem de dados para o sistema do Núcleo de Apoio às Pessoas com Anemia Falciforme e Glaucoma (NAAFAG) da Prefeitura de Caxias-MA. Ele serve como guia para o desenvolvimento, garantindo consistência e alinhamento da equipe.**

## 2. Visão Geral do Projeto (Baseada nos Documentos Fornecidos)

**O objetivo principal do sistema NAAFAG é apoiar o programa de acompanhamento integral de pacientes com Anemia Falciforme e Glaucoma. Suas funções incluem:**

* **Busca Ativa e Cadastramento:** **Identificação, registro e inclusão de pacientes no programa através de equipes de saúde da família, agentes comunitários, escolas e outras instituições.**
* **Encaminhamento e Tratamento:** **Gerenciamento do fluxo de encaminhamento para tratamento especializado e acompanhamento das condições dos pacientes.**
* **Acompanhamento Multidisciplinar:** **Suporte por uma equipe variada (assistentes sociais, psicólogos, enfermeiros, advogados) para garantir o bem-estar e direitos dos pacientes.**
* **Ações Educativas e Preventivas:** **Organização de campanhas, palestras e capacitações para conscientização e prevenção.**
* **Resultados Esperados:** **Redução de complicações, maior adesão ao tratamento, ampliação do diagnóstico precoce e fortalecimento da rede de atenção.**

## 3. Arquitetura do Sistema

### 3.1. Tipo de Arquitetura: Monólito

**Decisão:** **O sistema será construído como um monólito.**

**Justificativa:** **Esta abordagem oferece maior simplicidade e produtividade no desenvolvimento inicial, menor custo de operação e manutenção, e é ideal para equipes pequenas a médias. Permite entrega rápida de valor e, caso a complexidade ou escalabilidade exijam no futuro, a refatoração para microserviços é mais viável a partir de um monólito bem estruturado.**

### 3.2. Stack Tecnológica

| **Camada / Componente**   | **Tecnologia Escolhida**              | **Detalhes**                                                                                                                                                                                                              |
| ------------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Framework Web**         | **Ruby on Rails**                     | **Versão mais recente (no momento, Rails 7+). Adere às convenções e acelera o desenvolvimento.**                                                                                                                      |
| **Banco de Dados**        | **PostgreSQL**                        | **Relacional, robusto, escalável e bem suportado pelo Rails.**                                                                                                                                                           |
| **Frontend CSS**          | **Tailwind CSS**                      | **Utility-first, altamente configurável, leve em produção (via PurgeCSS) e rápido para prototipar UI.**                                                                                                               |
| **Frontend JavaScript**   | **StimulusJS**                        | **Framework JS leve e "minimal-opinionated" que complementa o Rails e o HTML, ideal para adicionar interatividade no frontend de forma organizada.**                                                                      |
| **Pré-processador CSS**  | **SCSS**                              | **Usado para organização, variáveis,** **@import** **de outros estilos e CSS customizado que não se encaixa nas utilidades do Tailwind.**                                                                 |
| **Autenticação**        | **Devise**                            | **Gem completa e amplamente utilizada para gerenciamento de usuários, login, logout, registro, recuperação de senha, etc.**                                                                                            |
| **Autorização**         | **Pundit**                            | **Gem focada em objetos e policies para controle granular de permissões (o que cada tipo de usuário pode fazer com cada recurso).**                                                                                     |
| **UI Administrativa**     | **ActiveAdmin**                       | **Gem para criação rápida de painéis administrativos, essencial para gerenciar dados e usuários sem construir todas as telas de CRUD manualmente.**                                                                  |
| **Tarefas em Background** | **Sidekiq (com Redis)**               | **Para processamento assíncrono de tarefas demoradas (ex: envio de e-mails, geração de relatórios). Escolha performática e escalável.**                                                                             |
| **Testes**                | **RSpec**                             | **Framework popular na comunidade Rails para testes BDD (Behavior-Driven Development), com DSL expressivo e legível.**                                                                                                   |
| **Padrões de Projeto**   | **Models Enxutos, Services, Helpers** |                                                                                                                                                                                                                                 |
|                                 |                                             | **Models:** **Focados na persistência e relacionamentos.**`<br>`**Services:** **Encapsulam a lógica de negócio complexa.**`<br>`**Helpers:** **Lógica de apresentação em views.** |

## 4. Modelagem de Dados (High-Level)

**A modelagem de dados segue a premissa de manter os modelos principais (**User**) enxutos, delegando informações específicas para tabelas relacionadas.**

### 4.1. Modelos de Autenticação e Perfil

* **User**

  * **Propósito:** **Gerenciamento de login e acesso ao sistema.**
  * **Atributos:**

    * **id** **(PK)**
    * **email** **(string, único, para login)**
    * **password_digest** **(string, para senha hasheada)**
    * **active** **(boolean, default:** **true**, para habilitar/desabilitar acesso)
    * **created_at**, **updated_at**
  * **Associações:**

    * **has_one :profile**
    * **has_many :user_roles**
    * **has_many :roles, through: :user_roles**
    * **has_one :professional**
    * **has_one :patient**
* **Role**

  * **Propósito:** **Define os papéis que um usuário pode ter no sistema.**
  * **Atributos:**

    * **id** **(PK)**
    * **name** **(string, único: "Admin", "Profissional", "Paciente")**
    * **description** **(text, opcional)**
    * **created_at**, **updated_at**
  * **Associações:**

    * **has_many :user_roles**
* **UserRole**

  * **Propósito:** **Tabela de junção para relacionar usuários a seus papéis.**
  * **Atributos:**

    * **id** **(PK)**
    * **user_id** **(FK para** **User**)
    * **role_id** **(FK para** **Role**)
    * **created_at**, **updated_at**
  * **Associações:**

    * **belongs_to :user**
    * **belongs_to :role**
* **Profile**

  * **Propósito:** **Armazena dados pessoais genéricos para qualquer tipo de usuário.**
  * **Atributos:**

    * **id** **(PK)**
    * **user_id** **(FK para** **User**, único)
    * **first_name** **(string)**
    * **last_name** **(string)**
    * **full_name** **(string, pode ser calculado ou persistido)**
    * **birth_date** **(date)**
    * **cpf** **(string, único, pode ser nulo para admins)**
    * **phone_number** **(string)**
    * **gender** **(string, opcional: "Masculino", "Feminino", "Outro")**
    * **created_at**, **updated_at**
  * **Associações:**

    * **belongs_to :user**
    * **has_one :address**
* **Address**

  * **Propósito:** **Armazena informações de endereço.**
  * **Atributos:**

    * **id** **(PK)**
    * **profile_id** **(FK para** **Profile**)
    * **street** **(string)**
    * **number** **(string)**
    * **complement** **(string, opcional)**
    * **neighborhood** **(string)**
    * **city** **(string)**
    * **state** **(string)**
    * **zip_code** **(string)**
    * **address_type** **(string, opcional: "Residencial", "Comercial")**
    * **created_at**, **updated_at**
  * **Associações:**

    * **belongs_to :profile**

### 4.2. Modelos de Especialização de Usuário

* **Professional**

  * **Propósito:** **Armazena dados específicos de profissionais da equipe (assistentes sociais, psicólogos, enfermeiros, médicos, etc.).**
  * **Atributos:**

    * **id** **(PK)**
    * **user_id** **(FK para** **User**, único)
    * **professional_registration_number** **(string, ex: CRM, COREN, OAB)**
    * **specialty** **(string, ex: "Hematologista", "Oftalmologista", "Pediatra", "Assistente Social", "Psicólogo", "Enfermeiro", "Advogado", "Agente de Saúde", "Administrativo")**
    * **created_at**, **updated_at**
  * **Associações:**

    * **belongs_to :user**
    * **has_many :appointments**
    * **has_many :visits**
    * **has_many :educational_events**
* **Patient**

  * **Propósito:** **Armazena dados específicos de pacientes do programa.**
  * **Atributos:**

    * **id** **(PK)**
    * **user_id** **(FK para** **User**, único)
    * **municipal_registration_id** **(string, único, se houver um ID no sistema municipal)**
    * **has_sickle_cell_disease** **(boolean, default:** **false**)
    * **sickle_cell_diagnosis_date** **(date, opcional)**
    * **has_glaucoma** **(boolean, default:** **false**)
    * **glaucoma_diagnosis_date** **(date, opcional)**
    * **family_history_sickle_cell** **(boolean, default:** **false**)
    * **family_history_glaucoma** **(boolean, default:** **false**)
    * **last_active_search_contact** **(date, opcional, data do último contato da busca ativa)**
    * **active_search_origin** **(string, opcional, ex: "Equipe Saúde Família", "Agente Comunitário", "Escola", "Associação")**
    * **status_sickle_cell_treatment** **(string, opcional, ex: "Em Tratamento", "Sem Tratamento", "Referenciado", "Aguardando Avaliação")**
    * **status_glaucoma_treatment** **(string, opcional, ex: "Em Tratamento", "Sem Tratamento", "Referenciado", "Aguardando Avaliação")**
    * **referral_to_external_center** **(text, opcional, descrição para onde foi referenciado)**
    * **observations** **(text, opcional)**
    * **created_at**, **updated_at**
  * **Associações:**

    * **belongs_to :user**
    * **has_many :appointments**
    * **has_many :prescriptions**
    * **has_many :visits**

### 4.3. Outros Modelos Essenciais (A Serem Detalhados Posteriori)

* **Appointment** **(Consulta/Atendimento):** **Para registrar interações entre profissionais e pacientes.**

  * **patient_id**, **professional_id**, **date**, **type**, **notes**, etc.
* **Medicine** **(Medicamento):** **Catálogo de medicamentos.**

  * **name**, **active_ingredient**, **dosage**, **description**, etc.
* **Prescription** **(Prescrição):** **Para registrar medicamentos prescritos a pacientes.**

  * **patient_id**, **medicine_id**, **appointment_id**, **quantity**, **frequency**, **start_date**, **end_date**, **delivered_by_government_pharmacy**, **delivery_date**, etc.
* **EducationalEvent** **(Evento Educativo):** **Campanhas, palestras, capacitações.**

  * **title**, **description**, **date**, **location**, **target_audience**, **event_type**, **responsible_id**, etc.
* **PartnerOrganization** **(Organização Parceira):** **Registra UBS, Secretarias, Clínicas, etc.**

  * **name**, **type**, **contact_person**, **phone**, **email**, etc.
* **Visit** **(Visita Domiciliar):** **Para registro de visitas de enfermagem ou agentes.**

  * **patient_id**, **professional_id**, **date**, **notes**, **outcome**, etc.

## 5. Regras de Negócio Chave (Extraídas dos Documentos)

### 5.1. Busca Ativa e Cadastramento

* **Identificação:** **Pacientes são identificados por sinais, sintomas ou histórico familiar de Anemia Falciforme e/ou Glaucoma.**
* **Triagem:** **Aplicação de questionários e triagens específicas.**
* **Confirmação Diagnóstica:** **Exames laboratoriais (Anemia Falciforme) e oftalmológicos (Glaucoma).**
* **Cadastro:** **Pacientes confirmados são incluídos em um cadastro municipal para acompanhamento contínuo.**
* **Busca Ativa:** **Realizada por equipes de Saúde da Família, agentes comunitários de saúde e parcerias com escolas, associações e instituições locais.**

### 5.2. Encaminhamento e Tratamento

* **Protocolo Clínico:** **Após o diagnóstico, o paciente é encaminhado para tratamento especializado seguindo protocolos clínicos específicos para cada condição.**
* **Anemia Falciforme:** **Acompanhamento hematológico, controle de crises dolorosas, prevenção de complicações e orientação familiar.**
* **Glaucoma:** **Avaliação oftalmológica contínua, controle da pressão intraocular e uso regular de medicamentos.**
* **Referência:** **Casos mais graves ou complexos são referenciados para centros de referência regionais ou estaduais.**
* **Controle de Medicamentos:** **O sistema deve auxiliar no controle e distribuição de medicamentos pela farmácia do governo.**

### 5.3. Acompanhamento Multidisciplinar

* **Assistente Social:** **Orientação sobre benefícios sociais, inclusão em programas públicos e direitos.**
* **Psicólogo:** **Suporte emocional e acompanhamento para pacientes e familiares.**
* **Equipe de Enfermagem:** **Visitas domiciliares, orientações sobre cuidados e administração de medicamentos.**
* **Advogados:** **Apoio jurídico em questões de acesso à saúde e direitos de pessoas com doenças crônicas.**

### 5.4. Ações Educativas e Preventivas

* **Campanhas:** **Promoção de campanhas educativas, palestras em escolas e comunidades.**
* **Capacitação:** **Treinamento para profissionais de saúde.**
* **Foco:** **Prevenção, diagnóstico precoce e adesão ao tratamento.**

### 5.5. Gestão de Dados e Segurança

* **Confidencialidade:** **Dados dos pacientes são sensíveis e devem ser tratados com a máxima confidencialidade e segurança.**
* **Integridade:** **Garantia da integridade dos dados registrados.**
* **Auditoria:** **Registro de quem fez o quê e quando (implícito na necessidade de gestão).**
* **Acesso Controlado:** **Uso de autenticação (Devise) e autorização (Pundit) para controlar o acesso às funcionalidades e dados.**

## 6. Próximos Passos de Implementação

**Com este documento como base, os próximos passos no desenvolvimento serão:**

* **Criação do projeto Rails e configuração inicial das gems.**
* **Geração das migrations e modelos para a estrutura de** **User**, **Role**, **UserRole**, **Profile**, **Address**, **Professional** **e** **Patient**.
* **Implementação das associações nos modelos.**
* **Configuração do Devise para autenticação.**
* **Configuração do RSpec para testes.**
* **População inicial de dados (**seeds.rb**) para** **Roles** **e um** **Admin** **de teste.**
