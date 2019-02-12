project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: up-local
up-local: secrets
	cat website.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
	cat email.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
	kubectl apply -f msgstore.yaml
	cat renderer.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
	kubectl apply -f proxy.yaml
	\
	kubectl expose deployment proxy --type=LoadBalancer --name=cast \
		--port 3000 --target-port 80

.PHONY:secrets
secrets:
	for secret in secret-*.yaml; do kubectl apply -f $$secret; done

.PHONY: down
down:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

