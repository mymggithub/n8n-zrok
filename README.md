# n8n-zrok

First start zrok
```
docker compose up -d zrok
```
You may want to make entrypoint.sh and update_env.sh executable 

```
chmod +x entrypoint.sh
```

```
chmod +x update_env.sh
```

```
./update_env.sh
```

Once it gets the webhook you can run n8n
```
docker compose up -d n8n
```
