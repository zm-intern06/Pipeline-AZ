.PHONY: init$
init:$
    terraform init$
$
.PHONY: plan$
plan:$
    terraform plan$
$
.PHONY: apply$
apply: validate$
    terraform apply --auto-approve$
$
.PHONY: format$
format:$
    terraform fmt$
$
.PHONY: validate$
validate:$
    terraform validate$
$
.PHONY: destroy$
destroy:$
    terraform destroy --auto-approve$
$
.PHONY: refresh$
refresh:$
    terraform refresh$
$
.PHONY: checkov$
checkov:$
    checkov --directory .$
$
.PHONY: az-login-registry$
az-login-registry: ## login into the Azure using the username and password$
$
ifeq ((REGISTRY_NAME),)$
    @echo "[Error] Please specify a REGISTRY_NAME"$
    @exit 1;$
endif$
$
    az acr login --name (REGISTRY_NAME)$
$
.PHONY: build-push-docker-image$
build-push-docker-image: az-login-registry$
    cd ./../my-project && docker build -t (REGISTRY_NAME).azurecr.io/sampleapi .$
    docker tag (REGISTRY_NAME).azurecr.io/sampleapi:latest (REGISTRY_NAME).azurecr.io/sampleapi:v1$
    docker push (REGISTRY_NAME).azurecr.io/sampleapi:v1 i