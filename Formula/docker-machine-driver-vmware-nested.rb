class DockerMachineDriverVmwareNested < Formula
  desc "VMware Fusion & Workstation docker-machine driver with nested virtualization support"
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/cchengleo/docker-machine-driver-vmware.git",
    :tag      => "v0.1.1.1",
    :revision => "429c6516922337cc9d838698ffea20899ef3da0c"

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/cchengleo/docker-machine-driver-vmware"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-vmware",
            "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
