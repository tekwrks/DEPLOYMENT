project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: up-local
up-local:
	cat website.yaml | ./substitute.sh REPO ${localrepo} | kubectl apply -f -

.PHONY: down
down:
	kubectl delete -f website-deployment.yaml

