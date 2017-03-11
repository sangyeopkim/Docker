# Docker

## Step 1
### apt-get 최소 패키지 설치
``` 
docker images -> ubuntu 있는지 확인
```
```
docker run --rm -it ubuntu:16.04 /bin/bash
```
```
apt-get update
```
```
apt-get install python3
```
```
apt-get install python3-pip
```
```
apt-get install nginx
```

## Step 2
```
cd /srv
```
```
mkdir app
```
```
pip3 install django
```
```
pip3 install uwsgi
```
```
django-admin startproject eb
```
```
cd /eb
```
```
python3 manage.py runserver -> 서버 작동하는지 확인
```

## Step 3
Step 1, 2 의 내용들을 매번 입력하기 힘들기 때문에 pycharm 에 작성해둔다.  
1. 가장 상위 폴더에서 ```Dockerfile``` 생성  
Dockerfile

```
FROM    ubuntu:16.04
MAINTAINER dev@zelf.com -> 그냥 본인 email 주소

RUN apt-get update
RUN apt-get install python3
RUN apt-get install python3-pip
RUN apt-get install nginx

WORKDIR /srv
RUN mkdir app
WORKDIR /srv/app
```

## Step 4
### image 생성
```Dockerfile``` 에 작성한 코드가 잘 작동 되는지 확인   
```Dockerfile``` 이 있는 위치에서 명령어 입력  
```docker build -t eb .```  
```eb```는 docker image 이름  
```.```은 현재 경로

명령어를 실행하면,  

```
...
After this operation, 33.2 MB of additional disk space will be used.  
Do you want to continue? [Y/n] Abort.
The command '/bin/sh -c apt-get install python3' returned a non-zero code: 1
```
라고 Error 메세지가 나온다.  
docker 는 자동실행이기 때문에 ```[Y/n]``` 에서 선택을 할 수 없기 때문이다.  
이를 해결하기 위해 ```Dockerfile```을 다음과 같이 옵션(-y)을 추가 해 준다.  
 
```
FROM    ubuntu:16.04
MAINTAINER dev@zelf.com

RUN apt-get -y update
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN apt-get -y install nginx

WORKDIR /srv
RUN mkdir app
WORKDIR /srv/app
```
그리고 나서 다시 명령어 실행  
```docker images```를 통해 현재 생성된 image 들을 확인할 수 있음  
```eb``` 라는 image 가 생성된 것 확인 가능

## Step 5
```
docker run --rm -it eb /bin/bash
```

이 명령어를 통해 docker run을 실행하는 image 가 ```eb``` 라는 뜻  
```eb``` image 로 container 가 생성된 것  
여기서는 ```python3``` 와 ```pip3``` 가 있음을 확인 가능  

> 이런식으로 image를 만들어 놓으면 container를 열 때 마다 따로 설치할 필요 없이 있는 상태 그대로를 사용할 수 있음  

Docker image는 생성되어 있는 image 가 있으면 image를 생성할 때 마다 계속 덮어씌우면서 작업을 실행함  
그렇기 때문에 추가 작업이 필요할 때 마다 build 를 하게 되면 ```Dockerfile``` 에 있는 ```RUN``` 명령어를 계속해서 실행해야 하는 불편함이 있음  
이를 해결하기 위해 ```_Dockerfile_base``` 파일을 추가하고 기본적인 작업들을 따로 관리해 준다  

```_Dockerfile_base```

```
FROM    ubuntu:16.04
MAINTAINER dev@zelf.com

RUN apt-get -y update
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN apt-get -y install nginx
```

그 다음 아래 명령어를 통해 ```_Dockerfile_base```를 기준으로 ```eb-base``` 라는 image 를 생성  

```
docker build . -t eb-base -f _Dockerfile_base
```


```docker images``` 를 통해 ```eb-base``` 생성된 것 확인 가능  


```eb-base``` 를 기준으로 작업을 하기 위해 ```Dockerfile``` 수정 


```
FROM    eb-base	
MAINTAINER dev@zelf.com

#RUN apt-get -y update		
#RUN apt-get -y install python3
#RUN apt-get -y install python3-pip
#RUN apt-get -y install nginx

WORKDIR /srv
RUN mkdir app
WORKDIR /srv/app

```


다시 build  

```
docker build -t eb . 
```

build 후, ```docker images```로 확인  
기존에 만들었던 ```eb``` image 가 ```<none>``` 으로 바뀌고 새로운 ```eb```가 생성된 것 확인 가능  


## Docker 명령어
### image 삭제
#### Delete all docker containers
```docker rm $(docker ps -a -q)```  

#### Delete all docker images
```docker rmi $(docker images -q)```

#### Delete name docker images force
```<none>``` 삭제
```docker rmi -f $(docker images --filter "dangling=true" -q)```

### 실행중인 컨테이너에 명령 실행
```docker exec [container id] [실행할 명령]```

#### 접속 후 쉘 실행하고 싶은 경우
```docker exec -it [container id] /bin/bash```








