import { rgb8, bold } from "std/fmt/colors.ts";

export function title(text: string) {
  console.log(bold(`${rgb8("###", 208)} ${text}`));
}
