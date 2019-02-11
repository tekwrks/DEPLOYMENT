project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: up-local
up-local:
	cat website.yaml | ./substitute.sh REPO ${localrepo} | kubectl apply -f -
	cat proxy-config.yaml | kubectl apply -f -
	cat proxy.yaml | kubectl apply -f -
	cat proxy-service.yaml | kubectl apply -f -

.PHONY: down
down:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

