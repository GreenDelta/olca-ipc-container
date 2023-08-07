import 'dart:io';

const IMAGE = "olca-ipc-server";

main(List<String> args) {
  if (args.isEmpty) {
    _build();
  } else {
    switch (args[0]) {
      case "build":
        _build();
        break;
      default:
        print("error: unknown command: ${args[0]}");
    }
  }
}

void _build() {
  print("build image $IMAGE ...");
  _docker(["build", "-t", IMAGE, "."]);
}

ProcessResult _docker(List<String> args) {
  final pr = Process.runSync("docker", args);
  if (pr.exitCode != 0) {
    print(pr.stderr);
    print("ERROR: command failed: docker ${args.join(' ')}");
    exit(pr.exitCode);
  }
  return pr;
}
