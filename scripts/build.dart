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
      case "clean":
        _clean();
        break;
      default:
        print("error: unknown command: ${args[0]}");
    }
  }
}

_build() {
  _clean();
  print("  build image $IMAGE");
  _docker(["build", "-t", IMAGE, "."]);
}

_clean() {
  // stop a possible running container
  _eachLineOf(_docker(["ps"]), (line) {
    if (line.length < 2) return;
    final container = line.last.trim();
    final image = line[1].trim();
    if (image == IMAGE) {
      print("  stop container $container (image: $image)");
      _docker(["stop", container]);
    }
  });

  // delete a stopped container
  _eachLineOf(_docker(["ps", "-a"]), (line) {
    if (line.length < 2) return;
    var containerId = line[0].trim();
    var image = line[1].trim();
    if (image == IMAGE) {
      print("  delete container ${containerId} (image: ${image})");
      _docker(["rm", containerId]);
    }
  });

  // delete image
  _eachLineOf(_docker(["image", "ls"]), (line) {
    if (line.length < 2) return;
    var image = line[0].trim();
    if (image == IMAGE) {
      print("  delete image ${image}");
      _docker(["image", "rm", image]);
    }
  });
}

_eachLineOf(ProcessResult pr, Function(List<String>) fn) {
  final out = pr.stdout;
  if (out == null) {
    return;
  }
  final ws = RegExp("\\s+");
  for (var line in out.toString().split("\n")) {
    var parts = line.trim().split(ws);
    fn(parts);
  }
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
