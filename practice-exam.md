# Questionable the First Time Around

When querying the configuration of a running container called 'myweb', which command would display the container's IP Address?

Choose the correct answer:
docker run inspect myweb | grep IP
docker myweb inspect | grep IP
docker inspect myweb | grep IPAddress
None of the Above


You need to instantiate a container called 'myweb' running an Apache application from the image 'httpd:latest' on your system, and map the container port 80 to a port on the host in a specified range (based on availability). Which command would accomplish this task?

Choose the correct answer:
docker run -d --name myweb --ports 80:80-85 httpd:latest
None of the above.
docker run -d --name myweb -p 80:80-85 httpd:latest
docker run -d --name myweb -p 80-85:80 httpd:latest

You have a node in your cluster that has already been marked as down related to maintenance that needs to be performed. You want to now remove that node from the cluster completely using the appropriate command from the choices below.

Choose the correct answer:
docker node rm [NODE ID]
docker node --leave [NODE ID]
docker node --exit [NODE ID]
None of the above.



Which of the following 'namespaces' does Docker use to maintain its isolation and security model? (Choose all that apply)

Choose the 2 correct answers:
 PID
 Network
 User
 Memory



Your production cluster has come under heavy load as a result of a recent marketing campaign. Your engineering team has already provisioned additional node capacity and they have already joined them to the cluster. You need to scale your environment to a total of 12 replicas using one of the following commands:

Choose the correct answer:
docker scale swarm --nodes=12
docker service scale [SERVICE NAME]=12 <-- I thought this was done with another command.
docker swarm nodes=12
docker service replicas=12


# Questions I Got Wrong To Revisit
13) You need to launch a detached web container based on the 'httpd' image on your system. That container should bind to a host directory called /my/webfiles to the /usr/local/apache2/htdocs directory on the container, to serve content from. Which of the following container instantiation commands would accomplish that goal?

Incorrect

Correct answer
docker run -d --mount type=bind,src=/my/webfiles,target=/usr/local/apache2/htdocs httpd

Explanation
Using the type=bind option along with the --mount directive is the proper way to expose the underlying host directory to the container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/3/module/150


38) Which of the following 'namespaces' does Docker use to maintain its isolation and security model? (Choose all that apply)

Incorrect

Correct answer
PID, Network

Explanation
The PID and Network namespaces mean that each container is isolated in terms of them, which maintains the isolation and separation of the container processes from underlying host services.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/12/module/150


## Questions I Got Wrong That Are Wrong.
36) In order to provide redundancy as you prepare your cluster for release to production, you need to join a second node to the cluster as a manager. One of the following commands will allow you to do so, which one is it?

Incorrect

Correct answer
docker swarm join-token manager

Explanation
Docker will display the necessary information for a manager or node to join a cluster during initialization. This command will allow you to retrieve that information for subsequent joins.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150

37) In Docker UCP Security, the term 'RBAC' stands for what?

Correct

Correct answer
Role Based Access Control

Explanation
RBAC is an acronym that determines what a user, team, or organization has access to on the cluster based on the role granted to them.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1378/lesson/4/module/150
