export const parseIni = (text: string) => {
  const result: {
    section: string;
    data: Record<string, string>;
  }[] = [];
  let currentSection: typeof result[0] | null = null;

  const lines = text.split("\n").map((l) => l.trim());
  for (const line of lines) {
    if (line === "") continue;
    if (line.startsWith("[") && line.endsWith("]")) {
      if (currentSection != null) {
        result.push(currentSection);
      }
      const section = line.substring(1, line.length - 1);
      currentSection = { section, data: {} };
      continue;
    }

    if (!currentSection) continue;

    const equalPosition = line.indexOf("=");
    if (equalPosition === -1) continue;

    const key = line.substring(0, equalPosition);
    const value = line.substring(equalPosition + 1);

    currentSection.data[key] = value;
  }

  if (currentSection != null) result.push(currentSection);

  return result;
};
