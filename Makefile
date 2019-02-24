project=tekwrks
name=cast

localrepo=${project}
remoterepo=gcr.io/${project}

.PHONY: all up services proxy
all: up expose-development
up: msgstore services proxy
services: website email user login post publish renderer
proxy:
	kubectl apply -f proxy.yaml

.PHONY: website email user login post publish renderer
website:
	cat website.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
email:
	cat email.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
user:
	cat user.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
login:
	cat login.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
post:
	cat post.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
publish:
	cat publish.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -
renderer:
	cat renderer.yaml | sed -e "s/\$${REPO}/${localrepo}/g" | kubectl apply -f -

.PHONY: expose-development
expose-development:
	kubectl expose deployment proxy --type=LoadBalancer --name=cast --port 3000 --target-port 80

.PHONY: msgstore
msgstore:
	kubectl apply -f msgstore.yaml

.PHONY: database
database:
	helm install --name database -f ./values-production.yaml stable/mongodb

.PHONY: secrets-development
secrets-development:
	for secret in secrets/development/secret-*.yaml; do kubectl apply -f $$secret; done

.PHONY: down
down:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

.PHONY: delete
delete: down
	kubectl delete persistentvolumes,persistentvolumeclaims,storageclasses,configmaps,secrets --all

