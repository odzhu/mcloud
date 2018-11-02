---
description: This document defines initial focus of the development
---

# MVP scope

### Requirements

* User should be able to build and deploy simplest kubernetes multicloud app
* Multicloud networking, platform and app functinality should be delivered as separate binaries and pluggable in a single **mcloud** tool
* Tools should be able to generate Terraform templates for review and customization purposes

### Features

* Environment - create, basic update, status, delete
* MVPC - CRUD the resource for AWS and Azure via CLI 
* Platform - create, status, delete
* App - k8s type only integrated via istio, build, deploy, status, delete

### Examples

Create multicloud environment

```text
$mcloud create env myFirstOne
```

Create multicloud VPC

```text
$mcloud create mvpc myFirstMVPC --cloud aws --cloud azure
```

Create multicloud k8s based multicloud platform

```text
$mcloud create platform myFirstMcloudK8s --type k8s --mvpc myFirstMVPC
```

Installing application to one or more clouds

```text
$ mcloud install myapp --clouds aws,azure
```

Initializing development workspace for sample kubernetes golang app

```text
$mcloud app --platform k8s --type golang init myapp
```

Switch environment context

```text
$mcloud config use-context MySecondEnvironment
```

{% hint style="info" %}
**$mcloud app install** can autocreate networking and platform resources if flagged, which is usefull as a quickstart.
{% endhint %}

