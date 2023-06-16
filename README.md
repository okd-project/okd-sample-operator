# Overview

A simple quick-start introduction on how to build an operator from scratch

This project assumes you have somew knowledge of golang and a high level understanding of operators

### What is the Operator SDK?

The Operator SDK is a framework that uses the controller-runtime library to make writing Operators easier by providing:

High level APIs and abstractions to write the operational logic more intuitively.
Tools for scaffolding and code generation to bootstrap a new project fast.
Extensions to cover common Operator use cases.

### How do I use it?

The following is the workflow for a new Go-based Operator with the Operator SDK:
 
 1.  Create a new Operator project using the SDK CLI.
 2.  Create a new Custom Resource Definition API Type using the SDK CLI.
 3.  Add your Custom Resource Definition (CRD) to your live Kubernetes cluster.
 4.  Define your Custom Resource Spec and Status.
 5.  Create a new Controller for your Custom Resource Definition API.
 6.  Write the reconciling logic for your Controller.
 7.  Run the Operator locally to test your code against your live Kubernetes cluster.
 8.  Add your Custom Resource (CR) to your live Kubernetes cluster and watch your Operator in action!
 9.  After you are satisifed with your work, run some Makefile commands to build and generate the Operator Deployment manifests.
 10. Optionally add additional APIs and Controllers using the SDK CLI.
 11. Use the okd-operator-pipeline to build, bundle and create a catalog for you new operator


### Prerequisites 

To start you will neeed the following software packages

- golang
- golangci-lint
- operator-sdk
- opm
- kustomize

There is a script in this repo to assist in getting the epackages for 
linux only, please contribute to get brew install etc for mac

Clone the repo 

```
git clone https://github.com/okd-project/okd-sample-operator
cd okd-sample-operator
```

Execute the script 

```
sudo ./operator-software-util.sh

```

Once all the packages have been installed we are ready to start with the scaffolding of the operator

**NB** A complete solution is provided in this repository (see the **solution** directory)

### Step 1

Create and initialize the project

**N.B.** The operator-sdk init expects the base directory to be empty (i.e no files etc).
Move the README.md and operator-software-util.sh to a tmp working directory (out of the base directory) for now

```
operator-sdk init --domain okd.io --repo github.com/okd-project/sample-operator
```

### Step 2

Create a simple SampleOperator API

```
operator-sdk create api --group=app --version=v1alpha1 --kind=SampleOperator --resource --controller
```
### Step 3

In the file sampleoperator_types.go inside of operator/api/v1aplpha1 change the following code:

```
// SampleOperatorSpec defines the desired state of SampleOperator
type SampleOperatorSpec struct {
	// +kubebuilder:validation:Minimum=1
	// +kubebuilder:validation:Maximum=5
	Replicas int32 `json:"replicas,omitempty"`
}

// SampleOperatorStatus defines the observed state of SampleOperator
type SampleOperatorStatus struct {
	PodNames          []string `json:"podNames"`
	AvailableReplicas int32    `json:"availableReplicas"`
}
```

### Step 4

If you are editing the API definitions (as in Step 3), generate the manifests such 
as CustomResource's or CustomResourceDefinition's by executing the following


```
make generate
make manifests
```

### Step 5

Edit the controllers/sampleoperator_controller.go file

Refer to the solution folder (to copy the sampleoperator_controler.go worked out example)

*For more detailed information in what is being done in the controller
please read the comments*

### Step 6 

As we have updated the sampleoperator_controller.go file and added dependencies execute the following

```
go mod tidy
```

### Step 7
To deploy and execute the controller (run locally so that we can verify/debug)
execute the following

```
KUBECONFIG=/<path-to-kubeconfig> make deploy

# scale down the manager (so we can run locally)
kubectl scale deployment.apps/operator-controller-manager -n operator-system  --replicas=0

KUBECONFIG=/<path-to-kubeconfig> make run
```

### Step 8

Edit the file config/samples/app_v1alpha1_sampleoperator.yaml to show the folling

```
apiVersion: app.okd.io/v1alpha1
kind: SampleOperator
metadata:
  labels:
    app.kubernetes.io/name: sampleoperator
    app.kubernetes.io/instance: sampleoperator-instance
    app.kubernetes.io/part-of: operator
    app.kubernetes.io/managed-by: kustomize
    app.kubernetes.io/created-by: operator
  name: sampleoperator-instance
spec:
  replicas: 2
```

Apply the changes

```
kubectl apply -f config/samples/app_v1alpha1_sampleoperator.yaml
kubectl get pods

```

### Step 9

Check the status of the controller

```
kubectl get sampleoperators.app.okd.io sample-instance -n operator-system -o yaml 
```

### Conclusion

This is an extremely simple solution, you may want to add other types of objects to watch/deploy

Use the makefile to build and push your specific version to a registry

The project **okd-operator-pipeline** can now be utilized to build, deploy and create a catalog for this operator.

For the **okd-operator-pipeline** to work on this repo consider using (or copying the make file in the solution)
as it has the correct recipes for the pipeline.

For more information about developing an operator please refer to the documentation for 
[Operator SDK](https://sdk.operatorframework.io/docs/building-operators/golang/quickstart/)
