# Arquitetura do Repositório

Este repositório segue o padrão **app-of-apps** do ArgoCD: uma única `Application` raiz, aplicada manualmente uma vez (`kubectl apply -f bootstrap/root-app.yaml`), observa recursivamente a pasta `apps/` e cria automaticamente uma `Application` filha para cada manifesto encontrado ali. Isso significa que adicionar um novo serviço ao cluster não exige tocar no bootstrap nem em nenhuma configuração do ArgoCD em si — basta versionar um novo arquivo `.yaml` em `apps/` apontando para a pasta correspondente em `services/`, e o próprio ArgoCD detecta e sincroniza a novidade no próximo ciclo de reconciliação.

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=argocd,kubernetes,yaml" height="48" alt="Arquitetura">
  </a>
</p>

- **App-of-apps via `bootstrap/root-app.yaml`**, a `Application` `root-app` usa `source.path: apps` com `directory.recurse: true`, ou seja, todo `.yaml` sob `apps/` (mesmo em subpastas) é tratado como definição de uma nova `Application` filha, com `syncPolicy.automated` (`prune: true`, `selfHeal: true`) e `CreateNamespace=true`.
- **Um manifesto por serviço em `apps/`**, cada arquivo (`ai-assistant.yaml`, `ai-validation.yaml`, `api-auth.yaml`, `api-core.yaml`, `api-mcp.yaml`, `api-messenger.yaml`, `api-recommendation.yaml`, `web-app.yaml`) declara uma `Application` independente, com `source.repoURL` apontando para este próprio repositório (`infra-gitops`), `targetRevision: main` e `source.path` apontando para `services/<nome-do-serviço>`. Diferente do que se poderia supor por convenção de outras organizações, o código-fonte de cada serviço vive em repositórios separados, mas os manifestos Kubernetes de todos eles ficam centralizados aqui, e não distribuídos em cada repositório de serviço.
- **`destination`** de cada `Application` de serviço aponta para `https://kubernetes.default.svc` (o próprio cluster onde o ArgoCD roda) no namespace `default`; a `root-app` é a exceção, sincronizada no namespace `argocd`.
- **`syncPolicy.automated`** com `prune: true` e `selfHeal: true` em toda `Application`, então qualquer divergência entre `services/<app>` e o estado real do cluster é corrigida automaticamente pelo ArgoCD, e recursos removidos do manifesto são removidos do cluster também — não há sync manual no fluxo normal.
- **Pasta `services/`**, contém, para cada serviço, o `Deployment` (imagem `docker.io/solarianetwork/<serviço>:latest`, probes, `envFrom` referenciando um `Secret` gerenciado fora deste repositório, requests/limits de CPU e memória), o `Service` (`ClusterIP`, expõe a porta interna do container) e, quando o serviço precisa ser acessível externamente, um `Ingress` (`ingressClassName: kong`, host no padrão `<serviço>.34.70.130.195.sslip.io`). Serviços internos, como `api-mcp`, não possuem `Ingress`.

```Tree do Repositório
├── .github/
│   ├── CODEOWNERS
│   ├── CONTRIBUTING.md
│   └── pull_request_template.md
├── apps/
│   ├── ai-assistant.yaml
│   ├── ai-validation.yaml
│   ├── api-auth.yaml
│   ├── api-core.yaml
│   ├── api-mcp.yaml
│   ├── api-messenger.yaml
│   ├── api-recommendation.yaml
│   └── web-app.yaml
├── bootstrap/
│   └── root-app.yaml
├── services/
│   ├── ai-assistant/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   ├── ai-validation/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   ├── api-auth/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   ├── api-core/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   ├── api-mcp/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── api-messenger/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   ├── api-recommendation/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
│   └── web-app/
│       ├── deployment.yaml
│       ├── ingress.yaml
│       └── service.yaml
├── README.md
├── ARCHITECTURE.md
├── RUNNING.md
├── LICENSE
├── .editorconfig
└── .gitattributes
```
