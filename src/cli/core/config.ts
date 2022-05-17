import { z } from "zod";
import { homeDir } from "./paths.ts";
import { readFile } from "denox/fs/mod.ts";
import { exists } from "std/fs/mod.ts";
import { join } from "std/path/mod.ts";

export type Config = {
  git: {
    name: string;
    email: string;
  };
  brew: {
    packages: string[];
  };
  apt: {
    repositories: [
      string,
      string,
      string[],
      { key?: [string, string]; arch?: string; trusted?: boolean }?,
    ][];
    pins: [string, string, number][];
    packages: string[];
  };
  asdf: {
    config: Record<string, string>;
  };
  dropbox: {
    links: {
      dropbox: string;
      darwin?: string;
    }[];
  };
};

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
