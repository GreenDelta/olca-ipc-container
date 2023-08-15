#!/bin/bash
java -Xmx4096M -cp "/app/lib/*" org.openlca.ipc.Server -timeout 30 -native /app/native -data /app/data "$@"
