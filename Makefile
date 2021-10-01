CERTS_DIR=certs
NAMESPACE=test-webhook
SERVICE_DNS="admission-webhook-example-svc.${NAMESPACE}.svc"

.EXPORT_ALL_VARIABLES:

generate:
	rm -rf output && mkdir output
	./scripts/gen-certs.sh
	./scripts/envvar-subst.sh

apply:
	kubectl apply -f output/ns.yaml
	kubectl -n ${NAMESPACE} apply -f output/

# not the prettiest make target
delete:
	-rm -rf output certs
	-kubectl delete ns ${NAMESPACE} --force --grace-period 0 &
	-kubectl delete ns app1 --force --grace-period 0 &
	-kubectl get namespace ${NAMESPACE} -o json > ns.json
	-sed -i '' "s/\"kubernetes\"//g" ns.json
	-kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f ns.json
	-kubectl get namespace app1 -o json > ns.json
	-sed -i '' "s/\"kubernetes\"//g" ns.json
	-kubectl replace --raw "/api/v1/namespaces/app1/finalize" -f ns.json

test:
	kubectl apply -f test-manifest/ns.yaml
	kubectl apply -f test-manifest/