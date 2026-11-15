// Helpers for the drawn macOS scenes in src/components/mock.

/** A length in points, scaled with the scene (see mock.css). */
export const pt = (n: number) => `calc(${Math.round(n * 1000) / 1000} * var(--pt))`;

let seq = 0;
/** A page-unique id for SVG defs. */
export const uid = (prefix: string) => `${prefix}${(seq++).toString(36)}`;
