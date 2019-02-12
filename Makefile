project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: up-local
up-local:
	cat website.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
	kubectl apply -f msgstore.yaml
	cat renderer.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
	kubectl apply -f proxy.yaml
	\
	kubectl expose deployment proxy --type=LoadBalancer --name=cast

.PHONY: down
down:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

