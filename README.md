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


### Prerequiesets

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




