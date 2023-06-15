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

Execute the script 

```
sudo ./operator-software-util.sh

```

Once all the packages have been installed we are ready to start with the scaffolding of the operator

#### Step 1

```
mkdir operator
cd operator
operator-sdk init --domain okd.io --repo github.com/okd-project/sample-operator
```
#### Step 2

```
operator-sdk create api --group=app --version=v1alpha1 --kind=SampleOperator --resource --controller
```
#### Step 3

In the file sampleoperator_types.go inside of operator/api/v1aplpha1 change the following code:

```
// SampleOperatorSpec defines the desired state of SampleOperator
type SampleOperatorSpec struct {
	// +kubebuilder:validation:Minimum=1
	// +kubebuilder:validation:Maximum=2
	Replicas int32 `json:"replicas,omitempty"`
}

// SampleOperatorStatus defines the observed state of SampleOperator
type SampleOperatorStatus struct {
	PodNames          []string `json:"podNames"`
	AvailableReplicas int32    `json:"availableReplicas"`
}
```

#### Step 4

```
make generate
make manifests
```

#### Step 5
Edit the controllers/sampleoperator_controller.go file

Refer to the solution folder (to copy the sampleoperator_controler.go worked out example)

### Step 6 

```
go mod tidy
```

### Step 7
```
MATCH_NAMESPACE=operator-system  KUBECONFIG=/<path-to-kubeconfig>/config make deploy

MATCH_NAMESPACE=operator-system  KUBECONFIG=/<path-to-kubeconfig>/config make run
```

```
cat config/samples/app_v1alpha1_sampleoperator.yaml
```

### Step 8

edit the file config/samples/app_v1alpha1_sampleoperator.yaml to show the folling

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
oc apply -f config/samples/app_v1alpha1_sampleoperator.yaml
oc get pods

```
