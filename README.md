# java-spring-boot-template

This is a template created using Java and spring-boot, which we can use for setting up Java micro services

For now, this project contains both maven and gradle as a build automation tool, and developers can use the tool accordingly.
To build and run the projects, use the below commands.

## Gradle
#
- gradle tasks
- gradle build
- gradle bootRun

### HOWTOs
#### Add 3rd party private maven package to gradle project

PR example can be found [here](https://github.com/Maersk-Global/alcl-java-spring-boot-template/pull/126/files)

Main focus has to be on the build.gradle file.

Repositories sample:
```groovy
repositories {
    mavenCentral()
    // Add this section to add github maven packaged from this repo
    maven {
        url = uri("https://maven.pkg.github.com/Maersk-Global/alcl-java-package-template")
        credentials {
            username = project.findProperty("gpr.user") ?: System.getenv("GITHUB_ACTOR")
            password = project.findProperty("gpr.key") ?: System.getenv("GITHUB_TOKEN")
        }
    }
}
```

Package reference sample under dependencies:
```groovy
dependencies {
    ...
    // the package published to https://maven.pkg.github.com/Maersk-Global/alcl-java-package-template
    implementation 'com.maersk.alcl:libtempl:bc1197eb9fa242ca53243ba168bf4662fffaabc3'
}
```

#### Build locally with 3rd party github package as a dependency 

You must export **GITHUB_TOKEN**, **GITHUB_ACTOR** env vars into your
current shell section.

GITHUB_TOKEN - Personal Access Token (PAT). *HINT*: Enable SSO. Can be generated [here](https://github.com/settings/tokens). It has to have at
least the following scope: *repo*, *write:packages*, *read:packages*, *read:org*  
GITHUB_ACTOR - your GH login. 

Then just

```bash
gradle build
```

#### Build Docker locally 

```bash
docker build --build-arg GITHUB_TOKEN="${GITHUB_TOKEN}" --build-arg GITHUB_ACTOR="${GITHUB_ACTOR}" -t local-alcl-java-spring-boot-template .
```

## Maven
#
- mvn clean install
- mvn spring-boot:run

## PREREQUISITES
#
* Local Kubernetes cluster (Minikube, Kind, Microk8s)
* Building the images requires local [Docker](https://www.docker.com/) installation
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) is used to manage Kubernetes cluster
* [Helm](https://helm.sh/) version 2.x

    1. Start minikube 
       1. minikube start
    2. Attach to minikube docker engine: ```eval $(minikube docker-env)```
    3. Build the docker image
       1. docker build --rm -t maerskao.azurecr.io/java-spring-boot-app:<your_named_Tag> .
    4. Build Helm templates and install them onto the Kubernetes Cluster 
       1. helm upgrade --install alcl-java-spring-boot-template ./k8s/chart --set-string image.version="<your_named_Tag>" -f ./k8s/envs/local.yaml
    5. Ensure that the deployment has been successful (log in to the pods and check that they are working correctly)
       1. kubectl get pods 
       2. kubectl exec -it <pod_name> bash
       3. do a curl on the localhost:8080 or any of the health check endpoints liveness or readiness.
    6. In order to check in local environment, run the following. This will print the URL to access the service. 
       1. minikube service <service-name> -n <namespace> --url
        

Note:
1. Tune the resources limits in deployment yaml file if pods are not in ready state.
2. To be able to switch back to the docker desktop you need to execute ```eval $(docker-machine env -u)```
3. Download docker-machine utility with your package manager (MACOS: brew install docker-machine)    

Reference: 
- https://confluence.maerskdev.net/display/ALP/Run+Local+Development+K8s+Cluster+using+Minikube
