# Quebra-Galho

Para rodar o container do docker, ir até a pasta Quebra-Galho\API_BancodeDados\API\quebragalho e
executar o comando docker-compose up --build -d no terminal

COMANDOS RELEVANTES - DOCKER

FORÇA O CONTAINER A RECONSTRUIR DO ZERO
docker-compose up -d --force-recreate --build

DERRUBA OS CONTAINERS E APAGA OS VOLUMES
docker-compose down -v

LIMPA TUDO QUE O DOCKER BAIXOU
docker system prune -a --volumes

Para acessar a documentação da api utilizar o link <http://localhost:8080/swagger-ui.html> com o container rodando
