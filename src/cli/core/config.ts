import { z } from "zod";
import { homeDir } from "./paths.ts";
import { readFile } from "denox/fs/mod.ts";
import { exists } from "std/fs/mod.ts";
import { join } from "std/path/mod.ts";

const LocalConfigModel = z.object({
  environment: z.record(z.string()),
});
export type LocalConfig = z.infer<typeof LocalConfigModel>;

export const localConfig = await (async (): Promise<LocalConfig> => {
  const filePath = join(await homeDir(), ".srk.json");
  if (!await exists(filePath)) {
    return {
      environment: {},
    };
  }
  const content = JSON.parse(await readFile(filePath));
  const result = LocalConfigModel.safeParse(content);
  if (!result.success) {
    console.log("Error parsing ~/.srk.json");
    console.log(result.error.issues);
    Deno.exit(1);
  }
  return result.data;
})();

const ConfigModel = z.object({
  git: z.object({
    name: z.string(),
    email: z.string().email(),
  }),
  brew: z.object({
    packages: z.array(z.string()),
  }),
  asdf: z.object({
    config: z.record(z.string()),
  }),
  dropbox: z.object({
    links: z.array(z.object({
      dropbox: z.string(),
      darwin: z.optional(z.string()),
    })),
  }),
});
export type Config = z.infer<typeof ConfigModel>;

export const config = await (async (): Promise<Config> => {
  const filePath = join(await homeDir(), ".srk/src/config.json");
  if (!await exists(filePath)) {
    throw new Error("Config not found on ~/.srk/src/config.json");
  }
  const content = JSON.parse(await readFile(filePath));
  const result = ConfigModel.safeParse(content);
  if (!result.success) {
    console.log("Error parsing ~/.srk/src/config.json");
    console.log(result.error.issues);
    Deno.exit(1);
  }
  return result.data;
})();
