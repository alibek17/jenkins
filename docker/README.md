# jenkins-docker
```docker tag f92d088d6980 alibek17/jenkins
```docker run -e "JENKINS_USER=admin" -e "JENKINS_PASS=password" -p 8080:8080 alibek17/jenkins