# Rodando o Projeto Localmente

Este repositório é um repositório de manifestos GitOps (ArgoCD) — não tem código de aplicação nem "servidor de desenvolvimento". Testar uma mudança aqui significa validar o manifesto YAML e, se possível, conferir o diff contra o cluster antes do merge em `main` (o que dispara o sync automático do ArgoCD, com `prune` e `selfHeal` habilitados em toda `Application`).

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=argocd,kubernetes,github" height="48" alt="Rodando o Projeto — ArgoCD">
  </a>
</p>

## Possíveis Impedimentos

- **ArgoCD CLI instalado**, necessário para rodar `argocd app diff` contra o cluster antes de abrir a Pull Request.
- **`kubectl` configurado com acesso ao cluster GKE**, sem isso não é possível validar o manifesto contra o estado real do cluster, só a sintaxe YAML.
- **Cluster GKE em pé**, como o cluster é efêmero (ver [Infra-platform](https://github.com/Solierrr/infra-platform)), validar contra um cluster real só é possível quando ele está ativo.
- **Mudanças aqui afetam produção diretamente**, ao contrário de um serviço rodando localmente, qualquer merge em `main` neste repositório é sincronizado automaticamente pelo ArgoCD — revise o diff com atenção antes de abrir a Pull Request, principalmente em `bootstrap/root-app.yaml`, já que ele controla a criação de todas as demais `Application`.

## Instalação do Projeto

### Iniciando o repositório com o Github

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=github,vscode" height="48" alt="Frameworks">
  </a>
</p>

Clone o repositório e abra no VS Code (com a extensão YAML para validação de schema).

```Comandos para clonar o repositório
git clone https://github.com/Solierrr/infra-gitops.git
cd ./infra-gitops
code . -r
```

### Validando os manifestos

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,argocd" height="48" alt="Frameworks">
  </a>
</p>

`kubectl apply --dry-run` valida a sintaxe e o schema do manifesto sem aplicar nada no cluster. `argocd app diff` mostra exatamente o que mudaria no cluster real, aplicação por aplicação — use o nome da `Application` (igual ao arquivo em `apps/`, sem a extensão), não o caminho do manifesto.

```Comandos para validar os manifestos de um serviço existente
kubectl apply --dry-run=client -f services/api-core/deployment.yaml
kubectl apply --dry-run=client -f services/api-core/service.yaml
kubectl apply --dry-run=client -f services/api-core/ingress.yaml

argocd app diff api-core
```

### Adicionando um novo serviço

<p>
  <a href="https://github.com/syvixor/skills-icons">
    <img src="https://skills.syvixor.com/api/icons?i=kubernetes,argocd" height="48" alt="Frameworks">
  </a>
</p>

Como o repositório segue o padrão app-of-apps (ver [ARCHITECTURE.md](./ARCHITECTURE.md)), um novo serviço exige apenas dois passos: criar a pasta `services/<novo-serviço>/` com `deployment.yaml` e `service.yaml` (e `ingress.yaml` se o serviço precisar ser exposto externamente), seguindo o padrão dos serviços já existentes, e criar `apps/<novo-serviço>.yaml` com a `Application` correspondente, apontando `source.path` para `services/<novo-serviço>`. Nenhuma mudança em `bootstrap/root-app.yaml` é necessária — a `root-app` já observa `apps/` recursivamente e cria a nova `Application` automaticamente após o merge em `main`.

```Comandos para validar o novo manifesto antes do merge
kubectl apply --dry-run=client -f apps/<novo-serviço>.yaml
kubectl apply --dry-run=client -f services/<novo-serviço>/deployment.yaml
kubectl apply --dry-run=client -f services/<novo-serviço>/service.yaml
```
