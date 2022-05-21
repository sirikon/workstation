import * as paths from "../core/paths.ts";
import { cmd } from "denox/shell/mod.ts";
import { join } from "std/path/mod.ts";
import { writeFile } from "denox/fs/mod.ts";

export async function getRequiredAptPackages() {
  const pciList = await getPciList();

  const result = [
    "firmware-linux",
    "firmware-linux-free",
    "firmware-linux-nonfree",
    "firmware-misc-nonfree",
  ];

  for (const pci of pciList) {
    if (pci.indexOf("VGA") >= 0 && pci.indexOf("AMD") >= 0) {
      result.push("firmware-amd-graphics");
    }
    if (pci.indexOf("Realtek") >= 0) {
      result.push("firmware-realtek");
    }
    if (pci.indexOf("Atheros") >= 0) {
      result.push("firmware-atheros");
    }
    if (pci.indexOf("Intel") >= 0 && pci.indexOf("Wireless") >= 0) {
      result.push("firmware-iwlwifi");
    }
  }

  result.sort();
  return result;
}

export async function configureXorgGraphicsCard() {
  const brand = await getGraphicsCardBrand();
  console.log("Graphics card brand: " + brand);

  const result = ((): [string, string[]] | null => {
    if (brand === "amd") {
      return ["20-amdgpu.conf", [
        'Section "Device"',
        '     Identifier "AMD"',
        '     Driver "amdgpu"',
        '     Option "TearFree" "true"',
        "EndSection",
        "",
      ]];
    }
    if (brand === "intel") {
      return ["20-intel.conf", [
        'Section "Device"',
        '     Identifier "Intel Graphics"',
        '     Driver "intel"',
        '     Option "TearFree" "true"',
        "EndSection",
        "",
      ]];
    }
    return null;
  })();

  if (result === null) return;
  const [filename, content] = result;

  const tempFilePath = join(await paths.homeDir(), ".srk", "temp", filename);
  await writeFile(tempFilePath, content);
  await cmd(["sudo", "mv", tempFilePath, `/etc/X11/xorg.conf.d/${filename}`]);
}

async function getGraphicsCardBrand() {
  const pciList = await getPciList();
  for (const pci of pciList) {
    if (pci.indexOf("VGA") >= 0) {
      if (pci.indexOf("AMD") >= 0) return "amd";
      if (pci.indexOf("Intel") >= 0) return "intel";
    }
  }
  return null;
}

async function getPciList() {
  const result = await cmd(["lspci"], { stdout: "piped" });
  if (!result.success) {
    throw result.error;
  }
  return (await result.output()).trim().split("\n");
}

async function updatePciids() {
  await cmd(["sudo", "update-pciids"]);
}
