Este mini projeto dentro de projeto, fiz para simular o que foi mostrado, porém em ruby.

## Como usar

Para iniciar o container e entrar nele é só executar.

```bash
docker-compose up ruby-kafka
docker exec -it ruby-kafka bash
```

Para usar, basta entrar no console com este código.

```bash
bin/console
```

Para criar um tópico e enviar uma mensagem é só executar.

```ruby
Producer.new(topic: 'test', message: {'teste': 'teste'}.to_json).execute
```

Para consumir as mensagens é só executar.

```ruby
Consumer.new(topic: 'test').execute
```