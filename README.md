# Sistema Runner

Repositório do trabalho prático da disciplina de Implementação e Integração de Software (UFG).

O objetivo do Runner é simplificar a execução e o gerenciamento de aplicações Java por linha de comando, com foco em:

- CLI de assinatura.
- assinador.jar (modo local e modo servidor HTTP).
- CLI de gerenciamento do simulador.

## Guia Rápido

- Requisitos e escopo: [docs/especificacao.md](docs/especificacao.md)
- Arquitetura e diagramas C4: [docs/design.md](docs/design.md)
- Plano de implementação: [docs/plano-revisitado-v2.md](docs/plano-revisitado-v2.md)
- Proposta de organização do repositório: [docs/organizacao-repositorio.md](docs/organizacao-repositorio.md)
- Linha do tempo das aulas: [docs/README.md](docs/README.md)

## Estrutura Atual

- [apps/assinatura-cli](apps/assinatura-cli): código-fonte do CLI de assinatura em Go.
- [docs](docs): requisitos, design, planejamento e documentação de apoio.
- [scripts/build](scripts/build): scripts de build local (Bash e PowerShell).
- [dist](dist): saída local de build/release e conteúdo legado de apoio em [dist/legacy](dist/legacy).

## Estado do Projeto

- O projeto está em evolução incremental por sprints, seguindo o plano revisado.
- A base inicial do CLI já existe e será expandida para cobrir todos os contêineres definidos no design.

## Como Contribuir

1. Leia os requisitos em [docs/especificacao.md](docs/especificacao.md).
2. Confirme o desenho arquitetural em [docs/design.md](docs/design.md).
3. Escolha uma história no plano em [docs/plano-revisitado-v2.md](docs/plano-revisitado-v2.md).
4. Implemente com testes e atualize a documentação relacionada.

## Histórico das Aulas

O histórico cronológico foi movido para [docs/README.md](docs/README.md).
