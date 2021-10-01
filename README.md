# Kubernetes webhook example
# Webhook rule 

This example uses a ValidatinAdmissionWebhook that expects Deployments to be called `dallas-demo` if they have annotation `tunde.meetup.com/prod: "true"`.

Based on this example:
- https://banzaicloud.com/blog/k8s-admission-webhooks/
- https://github.com/ssdowd/k8s-example-admission-controller/tree/4688a9226571aa1400aebe2ac997b934eb1e109e