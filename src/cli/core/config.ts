import { z } from "zod";
import { homeDir } from "./paths.ts";
import { readFile } from "denox/fs/mod.ts";
import { exists } from "std/fs/mod.ts";
import { join } from "std/path/mod.ts";

const ConfigModel = z.object({
  environment: z.record(z.string()),
});
export type Config = z.infer<typeof ConfigModel>;

const defaultConfig: Config = {
  environment: {},
};

export const config = await (async (): Promise<Config> => {
  const configPath = join(await homeDir(), ".srk.json");
  if (!await exists(configPath)) {
    return defaultConfig;
  }
  const configContent = JSON.parse(await readFile(configPath));
  const result = ConfigModel.safeParse(configContent);
  if (!result.success) {
    console.log("Error parsing ~/.srk.json")
    console.log(result.error.issues);
    Deno.exit(1);
  }
  return result.data;
})();
