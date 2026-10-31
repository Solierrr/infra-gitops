# Arquitetura do Repositório

Este repositório segue o padrão **app-of-apps** do ArgoCD: uma única `Application` raiz, aplicada manualmente uma vez (`kubectl apply -f bootstrap/root-app.yaml`), observa recursivamente a pasta `apps/` e cria automaticamente uma `Application` filha para cada manifesto encontrado ali. Isso significa que adicionar um novo serviço ao cluster não exige tocar no bootstrap nem em nenhuma configuração do ArgoCD em si — basta versionar um novo arquivo `.yaml` em `apps/` apontando para a pasta correspondente em `services/`, e o próprio ArgoCD detecta e sincroniza a novidade no próximo ciclo de reconciliação.

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=argocd,kubernetes,yaml" height="48" alt="Arquitetura">
  </a>
</p>

- **App-of-apps via `bootstrap/root-app.yaml`**, a `Application` `root-app` usa `source.path: apps` com `directory.recurse: true`, ou seja, todo `.yaml` sob `apps/` (agrupados por área em `ai/`, `api/`, `database/`, `infra/` e `web/`) é tratado como definição de uma nova `Application` filha, com `syncPolicy.automated` (`prune: true`, `selfHeal: true`) e `CreateNamespace=true`.
- **Um manifesto por serviço em `apps/`**, cada arquivo (`ai-accessibility.yaml`, `ai-assistant.yaml`, `ai-geographic.yaml`, `ai-operational.yaml`, `ai-validation.yaml`, `api-auth.yaml`, `api-core.yaml`, `api-email.yaml`, `api-messenger.yaml`, `api-notify.yaml`, `api-recommendation.yaml`, `feeddb.yaml`, `api-google.yaml`, `rabbitmq.yaml`, `grafana.yaml`, `mcp-database.yaml`, `web-app.yaml`, agrupados em subpastas por área) declara uma `Application` independente, com `source.repoURL` apontando para este próprio repositório (`infra-gitops`), `targetRevision: main` e `source.path` apontando para `services/<nome-do-serviço>`. Diferente do que se poderia supor por convenção de outras organizações, o código-fonte de cada serviço vive em repositórios separados, mas os manifestos Kubernetes de todos eles ficam centralizados aqui, e não distribuídos em cada repositório de serviço.
- **`destination`** de cada `Application` de serviço aponta para `https://kubernetes.default.svc` (o próprio cluster onde o ArgoCD roda) no namespace `default`; a `root-app` é a exceção, sincronizada no namespace `argocd`.
- **`syncPolicy.automated`** com `prune: true` e `selfHeal: true` em toda `Application`, então qualquer divergência entre `services/<app>` e o estado real do cluster é corrigida automaticamente pelo ArgoCD, e recursos removidos do manifesto são removidos do cluster também — não há sync manual no fluxo normal.
- **Pasta `services/`**, contém, para cada serviço, o `Deployment` (imagem `docker.io/solarianetwork/<serviço>:<versão>`, trocada pelo bot de release a cada release; enquanto um serviço não tem release, a tag continua `latest`, probes, `envFrom` referenciando um `Secret` gerenciado fora deste repositório, requests/limits de CPU e memória), o `Service` (`ClusterIP`, expõe a porta interna do container) e, quando o serviço precisa ser acessível externamente, um `Ingress` (`ingressClassName: kong`, host no padrão `<serviço>.34.70.130.195.sslip.io`). Serviços internos, como `mcp-database`, `api-email` e `infra-broker`, não possuem `Ingress`.
- **`rabbitmq`** (Application; os objetos do Kubernetes e a imagem ainda se chamam `infra-broker`) é o RabbitMQ 4 com o plugin STOMP (imagem `solarianetwork/infra-broker`, tag fixada na release do repositório do broker), usado pelo `api-messenger` como relay do WebSocket. Fica só dentro do cluster (`Service` com as portas STOMP `61613`, AMQP `5672` e a de gerenciamento `15672`, sem `Ingress`); o `api-messenger` o alcança por `RABBITMQ_HOST=infra-broker`. O usuário e a senha vêm do `Secret` `infra-broker-secrets` (`RABBITMQ_DEFAULT_USER` e `RABBITMQ_DEFAULT_PASS`), criado pelo `infra-platform` a partir da pasta `/broker` do Infisical. Os eventos são transitórios, então não há volume.
- **`grafana`** (Application com duas fontes; os objetos do Kubernetes ainda se chamam `infra-grafana`) usa a imagem oficial `grafana/grafana`, com um PVC de 2Gi, o `Ingress` `grafana.solarianetwork.site` (TLS pelo `letsencrypt-prod`, validação por DNS) e a senha do administrador no `Secret` `infra-grafana-secrets`. O login é o do Cloudflare Access (autenticação por JWT). As fontes de dados `prometheus`, `loki` e `tempo` apontam para o Grafana Cloud, onde o `otel-collector` entrega a telemetria; URL, usuário e token de leitura chegam por variáveis de ambiente do `Secret`. Os dashboards e o provider vêm do repositório `infra-otel-collector` (diretório `grafana`, segunda fonte da Application), que é o único dono deles.
- **`feeddb` é a exceção stateful**, em vez de `Deployment`, a pasta `services/feeddb/` declara um `StatefulSet` do Neo4j Community (banco `feeddb`, PVC de 5Gi, `Service` `ClusterIP` só com a porta Bolt `7687`, sem `Ingress`), mais o job de `database-bootstrap`. O grafo é uma projeção descartável do PostgreSQL do `api-core`: um `Job` com hook `PostSync` o reconstrói depois de cada sync em que o Neo4j fica saudável (`BeforeHookCreation` recria o `Job` a cada sync), e um `CronJob` diário (`concurrencyPolicy: Forbid`) o reconstrói periodicamente. Os dois usam a mesma imagem, fixada pelo sha do commit, e o `Secret` `database-bootstrap-secrets` criado pelo `infra-platform`. O `Secret` do Neo4j (`feeddb-secrets`) também vem de lá.

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
│   ├── mcp-database.yaml
│   ├── api-messenger.yaml
│   ├── api-recommendation.yaml
│   ├── feeddb.yaml
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
│   ├── mcp-database/
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
│   ├── feeddb/
│   │   ├── bootstrap-cronjob.yaml
│   │   ├── bootstrap-job.yaml
│   │   ├── service.yaml
│   │   └── statefulset.yaml
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

## Bump automático de imagens

Quando uma release do release-please é mergeada em um serviço, o workflow `docker-publish.yml` do `Solierrr/.github` publica a imagem com a tag `X.Y.Z` e chama o `gitops-bump.yml`. O bot `dive-robot` troca a tag nos manifestos deste repositório, abre a PR `chore: bump <serviço> to X.Y.Z`, espera os checks e a mergeia (é bypass da `main-protection` apenas por PR). O Argo CD sincroniza o rollout. O bot comenta na PR original do serviço com o resultado. Se nenhum manifesto usa a imagem do serviço, o bot só comenta isso e não abre PR.
