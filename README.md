# olca-ipc-container

This repository contains an example for packaging an openLCA v2 IPC server in a Docker container. This is done in a multi-stage build where the final image only contains the necessary resources to run the server. To build the image, just run:

```bash
cd olca-ipc-container
docker build -t olca-ipc-server .
```

This will package the IPC server and native calculation libraries in an image tagged as `olca-ipc-server`. The following example will start a container from that image:

```bash
docker run \
  -p 3000:8080 \
  -v $HOME/openLCA-data-1.4:/app/data \
  --rm -d olca-ipc-server \
  -db example --readonly
```

This will start the server in the container at port `8080` using `/app/data` as data folder. The data folder is mapped to the default openLCA workspace in the example and the port to `3000` of the host. More options can be passed in to the container after the image name (`olca-ipc-server`). In the example, the database is set to `example` (so `~/openLCA-data-1.4/databases/example` would be the full path of the database) and the server is run in `readonly` mode.

The server implements the JSON-RPC protocol of the openLCA API (see https://greendelta.github.io/openLCA-ApiDoc/ipc/). Here is an example `curl` command to list the product systems via the API:

```bash
curl -d '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "data/get/descriptors",
  "params": { "@type": "ProductSystem" }}'\
  -H "Content-Type: application/json"\
  -X POST http://localhost:3000
```
