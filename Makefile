project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: up-local
up-local:
	cat website.yaml | ./substitute.sh REPO ${localrepo} | kubectl apply -f -
	kubectl apply -f proxy-config.yaml && kubectl apply -f proxy.yaml
	\
	kubectl expose deployment proxy --type=LoadBalancer --name=cast

.PHONY: down
down:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

