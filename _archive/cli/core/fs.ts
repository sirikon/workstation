import { writeFile } from "denox/fs/mod.ts";

export type ExtendFileOpts = {
  file: string;
  prefix: string;
  suffix: string;
  data: string[];
};

export async function extendFile(opts: ExtendFileOpts) {
  if (!(await Deno.stat(opts.file)).isFile) {
    throw new Error(`${opts.file} is not a file`);
  }

  const contents = await Deno.readFile(opts.file)
    .then((d) => new TextDecoder().decode(d).split("\n"));

  const prefixIndex = contents.indexOf(opts.prefix);
  const suffixIndex = contents.indexOf(opts.suffix);

  if (prefixIndex === -1) {
    contents.push(opts.prefix, ...opts.data, opts.suffix, "");
  } else {
    const endIndex = suffixIndex >= 0 ? suffixIndex : contents.length - 1;
    contents.splice(
      prefixIndex,
      endIndex - prefixIndex + 1,
      opts.prefix,
      ...opts.data,
      opts.suffix,
    );
  }

  await writeFile(opts.file, contents);
}
