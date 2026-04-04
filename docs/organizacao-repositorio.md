# Proposta de Organização do Repositório - Sistema Runner

## 1. Objetivo

Esta proposta organiza o repositório para suportar, de forma clara e escalável, a implementação dos contêineres definidos no design C4:

- Assinador CLI (Go)
- assinador.jar (Java 21)
- Simulador CLI (Go)

Observação: o Simulador do HubSaúde permanece como sistema externo, mas seu ciclo de vida deve ser gerenciado pelo Simulador CLI.

## 2. Princípios de organização

- Separar por produto/contêiner, não por arquivo solto.
- Isolar código de aplicação de código compartilhado.
- Tratar build, release e assinatura de artefatos como parte do produto.
- Evitar versionar artefatos gerados (binários, jars de terceiros, estado local de runtime).
- Manter rastreabilidade entre requisitos (US-01 a US-05), código, testes e pipelines.

## 3. Estrutura-alvo do monorepo

```text
runner/
  apps/
    assinatura-cli/                # Contêiner: Assinador CLI (Go)
      cmd/assinatura/
      internal/
        app/
        domain/
        infra/
          javaexec/
          httpclient/
          process/
          runtime/
      test/
      go.mod

    assinador-java/                # Contêiner: assinador.jar (Java 21)
      src/main/java/
        br/ufg/runner/assinador/
          api/
          application/
          domain/
          infra/
            pkcs11/
            transport/http/
      src/test/java/
      pom.xml (ou build.gradle)

    simulador-cli/                 # Contêiner: Simulador CLI (Go)
      cmd/simulador/
      internal/
        app/
        domain/
        infra/
          downloader/
          process/
          ports/
          runtime/
      test/
      go.mod

  libs/
    go/
      runnerkit/                   # utilitários compartilhados entre CLIs
        exec/
        net/
        os/
        release/
        observability/
    java/
      common/                      # validações, DTOs e erros compartilháveis no Java

  docs/
    especificacao.md
    design.md
    plano-revisitado-v2.md
    diagramas/
    adrs/                          # decisões arquiteturais
    runbooks/                      # operação: start/stop/status, troubleshooting
    proposta-organizacao-repositorio.md

  scripts/
    build/
      build-all.ps1
      build-all.sh
    release/
      package.ps1
      package.sh
      sign-cosign.ps1
      sign-cosign.sh
    dev/
      bootstrap.ps1
      bootstrap.sh

  .github/
    workflows/
      ci-assinatura-cli.yml
      ci-assinador-java.yml
      ci-simulador-cli.yml
      release.yml

  dist/                            # saída local de build/release (ignorado)
  .gitignore
  README.md
```

## 4. Responsabilidades por contêiner

### 4.1 Assinador CLI (apps/assinatura-cli)

- Parsing e validação básica de entrada do usuário.
- Invocação do assinador em modo local (java -jar).
- Invocação do assinador em modo servidor (HTTP) por padrão.
- Gerenciamento de ciclo de vida do assinador (start, stop, status, timeout por inatividade).
- Provisionamento e resolução de JDK 21.
- Saída legível e mensagens de erro orientativas.

### 4.2 assinador.jar (apps/assinador-java)

- Validação rigorosa dos parâmetros de sign e validate.
- Simulação de criação e validação de assinatura.
- Endpoints HTTP /sign e /validate reutilizando a mesma regra de negócio.
- Integração PKCS#11 (com comportamento claro em indisponibilidade do dispositivo).

### 4.3 Simulador CLI (apps/simulador-cli)

- Comandos start, stop e status para simulador.jar.
- Verificação de portas antes de iniciar processo.
- Download dinâmico da última versão do simulador.jar em release.
- Reuso de jar local quando já atualizado.

## 5. Contratos e fronteiras técnicas

- Contrato de entrada/saída do assinador em JSON versionado.
- Estrutura de erro padronizada para modo local e modo HTTP.
- Persistência de estado local em diretório de runtime do usuário (ex.: ~/.hubsaude/).
- Definir formato único para:
  - arquivo de estado de processos (PID, porta, última atividade)
  - metadados de versão dos jars baixados

## 6. Estratégia de testes

- Testes unitários por contêiner.
- Testes de integração por fluxo:
  - assinatura-cli -> assinador.jar local
  - assinatura-cli -> assinador.jar HTTP
  - simulador-cli -> simulador.jar
- Testes de contrato (request/response e erros).
- Testes de aceite mapeados aos critérios de US-01 a US-05.

## 7. CI/CD e releases

- Pipeline por contêiner, com jobs independentes.
- Matrix de build para Windows/Linux/macOS (amd64) para os dois CLIs.
- Build do assinador.jar em Java 21.
- Release automatizada por tag SemVer.
- Publicação de:
  - binários dos CLIs
  - assinador.jar
  - checksums SHA256
  - assinatura Cosign (.sig e .pem)

## 8. Política de versionamento

- Monorepo com versão coordenada por release (tag única).
- Nomes de artefatos:
  - assinatura-<versão>-<os>-<arch>
  - simulador-<versão>-<os>-<arch>
  - assinador-<versão>.jar

## 9. Plano de migração incremental

### Fase 1 - Fundação do repositório

- Criar árvore apps/libs/scripts/.github/workflows.
- Migrar código atual do CLI para apps/assinatura-cli.
- Atualizar README com guias por contêiner.

### Fase 2 - Contêiner assinador.jar

- Criar projeto Java 21 em apps/assinador-java.
- Entregar sign/validate local + validação de parâmetros.
- Cobrir com testes unitários e integração.

### Fase 3 - Modo servidor e runtime

- Entregar endpoints HTTP no assinador.jar.
- Entregar start/stop/status/reuso de instância no assinatura-cli.
- Entregar timeout por inatividade.

### Fase 4 - Contêiner simulador-cli

- Criar apps/simulador-cli com start/stop/status.
- Implementar download dinâmico do simulador.jar.
- Cobrir fluxos de erro (porta ocupada, download indisponível, jar corrompido).

### Fase 5 - Release segura

- Configurar release por tag.
- Publicar artefatos + checksum + assinatura Cosign.
- Documentar verificação de integridade/autenticidade.

## 10. Definição de pronto (DoD) por contêiner

- Compila em ambiente limpo.
- Testes unitários e de integração passando.
- Logs e mensagens de erro claros.
- Documentação de uso e troubleshooting atualizada.
- Cobertura mínima dos critérios de aceite da sprint.

## 11. Riscos e mitigações

- Risco: acoplamento forte entre CLI e assinador.jar.
  - Mitigação: contrato JSON versionado + testes de contrato.
- Risco: divergência de comportamento local vs HTTP.
  - Mitigação: reutilizar mesma camada de aplicação no assinador.jar.
- Risco: fragilidade multiplataforma no gerenciamento de processo.
  - Mitigação: camada infra por SO e testes em matrix CI.
- Risco: falhas de supply chain em releases.
  - Mitigação: Cosign obrigatório + checksums + validação documentada.
