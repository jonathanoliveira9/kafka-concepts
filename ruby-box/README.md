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

Para enviar uma mensagem como Protobuf faça o seguinte, para saber mais sobre accesse [Protobuf](https://protobuf.dev/news/2023-04-20/).

```ruby
user = Example::User.new(id: 1, name: 'Test')
#  <Example::User: id: 1, name: "Test">

user_encoded = Example::User.encode(user)
# "\b\x01\x12\x04Test"

Producer.new(topic: 'test', message: user_encoded).execute
```

Para obter os dados vocẽ pode executar isto:

```ruby
Example::User.decode(user_encoded)

# <Example::User: id: 1, name: "Test">
```
