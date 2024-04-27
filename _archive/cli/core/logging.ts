import { bold, dim, rgb8 } from "std/fmt/colors.ts";

export function title(text: string) {
  console.log(bold(`${rgb8("###", 208)} ${text}`));
}

export function info(text: string) {
  console.log(dim(text));
}
