# Changelog

## 1.0.0 (2026-10-09)


### Features

* accept the origin host in the web-app ingress ([#25](https://github.com/Solierrr/infra-gitops/issues/25)) ([37939ad](https://github.com/Solierrr/infra-gitops/commit/37939adaeed3a8f7550963927108d5f15529bf17))
* add api-mcp deployment, service and argocd application ([6dc0657](https://github.com/Solierrr/infra-gitops/commit/6dc0657d93871e0825e567955d8697dc2a7ce461))
* add feeddb neo4j and the graph bootstrap job ([#26](https://github.com/Solierrr/infra-gitops/issues/26)) ([4272bac](https://github.com/Solierrr/infra-gitops/commit/4272bacd2aba6162d0511da7ecaa257b3bd8f954))
* add the stack and local cluster commands ([4e5c2cb](https://github.com/Solierrr/infra-gitops/commit/4e5c2cb7e7b9c34e4d77905cdec8a9567a94ef25))
* bootstrap App-of-Apps and onboard web-app + api-recommendation ([6f89ddb](https://github.com/Solierrr/infra-gitops/commit/6f89ddb5a8d7c1b6db8a4479ce69b12a2b960ea1))
* enable https on web-app ingress via cert-manager http-01 ([efb48a7](https://github.com/Solierrr/infra-gitops/commit/efb48a7eac055f39a3b0220d088f9468c0aae704))
* enable https on web-app via is-a.dev subdomain ([fd3a01f](https://github.com/Solierrr/infra-gitops/commit/fd3a01f35d224a775e87e5e72b03ee918781ba3a))
* expose api-core through kong ingress ([0f6745d](https://github.com/Solierrr/infra-gitops/commit/0f6745d2b9aab3788e9b5c1dce2feeeae68520d1))
* expose api-core through kong ingress ([36cf21a](https://github.com/Solierrr/infra-gitops/commit/36cf21a22416ae3672581eabc95cb54cadf28deb))
* expose backend services via kong ingress ([2d8eccf](https://github.com/Solierrr/infra-gitops/commit/2d8eccffe72627b6d36a96d8785286e7bbd5d86b))
* expose backend services via kong ingress ([8ff38b2](https://github.com/Solierrr/infra-gitops/commit/8ff38b2e9772ac2d1ba71bf514694e5e887a75c7))
* expose services under solarianetwork.site instead of sslip.io ([4716c03](https://github.com/Solierrr/infra-gitops/commit/4716c03a444dfdc4af767484fbcc968a66a00fa1))
* expose web-app via ingress ([c587837](https://github.com/Solierrr/infra-gitops/commit/c587837df4bbd5c462529efb326e5b990c7f5d73))
* expose web-app via ingress at a sslip.io hostname ([ef00319](https://github.com/Solierrr/infra-gitops/commit/ef00319819019b491864b0217a94c52ef5aa7218))
* hosting web ipv4 at cloudflare ([445e66a](https://github.com/Solierrr/infra-gitops/commit/445e66ae8fd6a24f46e45b21de9f62e2fc4e9f8c))
* hosting web ipv4 at cloudflare ([fd34411](https://github.com/Solierrr/infra-gitops/commit/fd344115d64a2e9ff7d5b9ef76f2dc87d71f522a))
* implementing http certify for web dns ([a81ca19](https://github.com/Solierrr/infra-gitops/commit/a81ca19809634ca0c4338d8c312e29192cd87241))
* implementing http certify for web dns ([aa13ae3](https://github.com/Solierrr/infra-gitops/commit/aa13ae3669c86abbc3e38e2e10ce13a9c4f9a89c))
* onboard ai-assistant, ai-validation, api-auth, api-core, api-messenger ([244f8d8](https://github.com/Solierrr/infra-gitops/commit/244f8d801b19412b28eb9feca6359088c7fb2ba4))
* point web-app ingress at the real domain ([#21](https://github.com/Solierrr/infra-gitops/issues/21)) ([7dd23e4](https://github.com/Solierrr/infra-gitops/commit/7dd23e459323469b7087f137f3c211d99fea0ca4))
* updating manual docker image commit to latest ([959ed96](https://github.com/Solierrr/infra-gitops/commit/959ed96904bc18d5dd8138cb814f167941999640))
* updating manual docker image commit to latest ([bcf259b](https://github.com/Solierrr/infra-gitops/commit/bcf259bcffeaa285629dc55a1d88e34aa281bf06))
* wire api-core and api-auth deployments to their secrets ([c2b3934](https://github.com/Solierrr/infra-gitops/commit/c2b3934d43b5f60418500424d6cfcabefdd08878))
* wire api-core and api-auth deployments to their secrets ([5d8f2c7](https://github.com/Solierrr/infra-gitops/commit/5d8f2c7eb360b4ae0e6f0ef894c10c58aa6b6269))
* wire api-messenger deployment to mongo secret ([069b349](https://github.com/Solierrr/infra-gitops/commit/069b3494938677dda1b46ac2bcf9287c34fc17be))
* wire api-messenger deployment to mongo secret ([f4c0f95](https://github.com/Solierrr/infra-gitops/commit/f4c0f954a07d7e92699380942d6a768a00dcfb57))
* wire infisical secrets and add api-mcp deployment ([4207fda](https://github.com/Solierrr/infra-gitops/commit/4207fda7ea6978a9f60f78a306a6c559fcbe7e4f))
* wire infisical secrets into ai-assistant, ai-validation and api-recommendation deployments ([9707a97](https://github.com/Solierrr/infra-gitops/commit/9707a9787c40a237af61fc027a2cdcab58321428))
* wire jwks and persistence service-to-service urls ([f56861b](https://github.com/Solierrr/infra-gitops/commit/f56861b675072dbb7c95e528cb66daf7b1263469))
* wire jwks and persistence service-to-service urls ([cfe6ad7](https://github.com/Solierrr/infra-gitops/commit/cfe6ad74b479c10af4b978926010da434aed4e21))


### Bug Fixes

* pass vault arguments correctly in PowerShell ([bef448b](https://github.com/Solierrr/infra-gitops/commit/bef448b2bb0c5bc75cbe50ce15477e531256596b))
* pin the database-bootstrap image to a published sha ([#28](https://github.com/Solierrr/infra-gitops/issues/28)) ([65ff65c](https://github.com/Solierrr/infra-gitops/commit/65ff65c946dd7c39e29132c6ab606baf00fb8f94))
* point web-app back to sslip.io for now ([0198410](https://github.com/Solierrr/infra-gitops/commit/019841033624c6c4924cdb7fc6078a6a05301b82))
* point web-app back to sslip.io until a real domain is bought ([2c8640a](https://github.com/Solierrr/infra-gitops/commit/2c8640af35f9000ab9887ef3dd88d97099761174))
* probe api-recommendation with the liveness and readiness endpoints ([#27](https://github.com/Solierrr/infra-gitops/issues/27)) ([8e69d5d](https://github.com/Solierrr/infra-gitops/commit/8e69d5df45262dd5965e3cd1edb65b25f6973657))
* scale down services still missing required secrets to 0 replicas ([4f45813](https://github.com/Solierrr/infra-gitops/commit/4f458133751f7f27961f5eacea2f2daada587c4e))
* scale down services still missing secrets to 0 replicas ([aa8fb57](https://github.com/Solierrr/infra-gitops/commit/aa8fb575da5185571e885078084d632c7cb81cd3))
* support powershell secret extraction ([38f915f](https://github.com/Solierrr/infra-gitops/commit/38f915f30c6a5b1ab953dd61d50ef777cdd6d972))
* use persistence_base_url to match api-auth application.properties ([597a367](https://github.com/Solierrr/infra-gitops/commit/597a367cadd3084c3d510baac9d10ff6a8371386))
