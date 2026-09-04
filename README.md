# infra-gitops

Este é o repositório GitOps central da organização Solierrr: aqui vivem os manifestos Kubernetes de cada serviço e as `Application` do [ArgoCD](https://argo-cd.readthedocs.io/) que os sincronizam com o cluster GKE. Em vez de aplicar `kubectl apply` manualmente contra o cluster, todo o estado desejado — Deployments, Services, Ingress e as próprias `Application` do ArgoCD — é declarado como YAML versionado aqui, e o ArgoCD assume a responsabilidade de manter o cluster convergido com o que está em `main`. O repositório segue o padrão **app-of-apps**: uma única `Application` raiz (`bootstrap/root-app.yaml`) observa a pasta `apps/`, e cada arquivo `.yaml` encontrado ali vira automaticamente uma nova `Application` filha, sem passos manuais adicionais além de adicionar o arquivo.

<p>

[![License](https://img.shields.io/github/license/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/blob/main/LICENSE)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/commits)
[![GitHub Issues](https://img.shields.io/github/issues/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/pulls)
[![GitHub Contributors](https://img.shields.io/github/contributors/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/graphs/contributors)
[![Release](https://img.shields.io/github/v/release/Solierrr/infra-gitops)](https://github.com/Solierrr/infra-gitops/releases)

</p>

<div align="center">

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=argocd,kubernetes,gcp,githubactions" height="48" alt="GitOps & Infrastructure">
  </a>
</p>

<p>

[![Argo CD](https://img.shields.io/badge/Argo_CD-EF7B4D?logo=argo&logoColor=white)](https://argo-cd.readthedocs.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![Kong](https://img.shields.io/badge/Kong-003459?logo=kong&logoColor=white)](https://konghq.com/)

</p>

</div>

Cada `Application` sob `apps/` (por exemplo `api-core.yaml`, `api-auth.yaml`, `web-app.yaml`) referencia um caminho da pasta `services/` deste mesmo repositório, onde ficam o `Deployment`, o `Service` e (quando exposto externamente) o `Ingress` daquele serviço. O ArgoCD sincroniza automaticamente qualquer divergência entre o que está em `services/<app>` e o estado real do cluster, com `prune` e `selfHeal` habilitados — ou seja, um merge em `main` já é o deploy.

## Aprofunde-se no Projeto!

- [ARCHITECTURE.md](./ARCHITECTURE.md), estrutura de pastas e o padrão app-of-apps em detalhe.
- [RUNNING.md](./RUNNING.md), como validar um manifesto localmente antes de abrir Pull Request.
- [DEPLOYMENT.md]({a confirmar}), pipeline de deploy da organização (ver [docs-warehouse/.github/DEPLOYMENT.md](https://github.com/Solierrr/docs-warehouse/blob/main/.github/DEPLOYMENT.md)).

## Contribuindo

- [.github/CONTRIBUTING.md](./.github/CONTRIBUTING.md), convenções de commit, branch e Pull Request.
- [CODE_OF_CONDUCT.md]({a confirmar}), código de conduta do projeto.
- [SECURITY.md]({a confirmar}), como reportar vulnerabilidades de segurança.
