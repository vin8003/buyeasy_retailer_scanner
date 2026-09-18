#!/usr/bin/env python3
"""Build a static HTML help centre from wiki/*.md (stdlib only)."""
from __future__ import annotations

import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
WIKI = ROOT / "wiki"
OUT = ROOT / "_site"


def md_href_to_html(href: str) -> str:
    if not href or href.startswith(("http://", "https://", "mailto:", "#")):
        return href
    path, frag = (href.split("#", 1) + [""])[:2]
    if path.endswith("README.md") or path.endswith("/README.md") or path == "README.md":
        path = path[: -len("README.md")] + "index.html"
    elif path.endswith(".md"):
        path = path[:-3] + ".html"
    return f"{path}#{frag}" if frag else path


def inline(text: str) -> str:
    parts: list[str] = []
    i = 0
    n = len(text)
    while i < n:
        if text.startswith("`", i):
            end = text.find("`", i + 1)
            if end != -1:
                parts.append(f"<code>{html.escape(text[i + 1 : end])}</code>")
                i = end + 1
                continue
        if text.startswith("**", i):
            end = text.find("**", i + 2)
            if end != -1:
                parts.append(f"<strong>{inline(text[i + 2 : end])}</strong>")
                i = end + 2
                continue
        if text.startswith("*", i) and not text.startswith("* ", i):
            end = text.find("*", i + 1)
            if end != -1:
                parts.append(f"<em>{inline(text[i + 1 : end])}</em>")
                i = end + 1
                continue
        m = re.match(r"!\[([^\]]*)\]\(([^)]+)\)", text[i:])
        if m:
            alt, src = m.group(1), m.group(2)
            parts.append(
                f'<img alt="{html.escape(alt)}" src="{html.escape(md_href_to_html(src))}">'
            )
            i += m.end()
            continue
        m = re.match(r"\[([^\]]+)\]\(([^)]+)\)", text[i:])
        if m:
            label, href = m.group(1), m.group(2)
            parts.append(
                f'<a href="{html.escape(md_href_to_html(href))}">{inline(label)}</a>'
            )
            i += m.end()
            continue
        if text[i] == "<" and re.match(r"<https?://[^>]+>", text[i:]):
            end = text.find(">", i)
            url = text[i + 1 : end]
            parts.append(f'<a href="{html.escape(url)}">{html.escape(url)}</a>')
            i = end + 1
            continue
        parts.append(html.escape(text[i]))
        i += 1
    return "".join(parts)


def render_table(rows: list[str]) -> str:
    bodies = []
    header = True
    for row in rows:
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        if header and all(re.match(r"^:?-+:?$", c) for c in cells):
            header = False
            continue
        tag = "th" if header else "td"
        if header:
            header = False
            bodies.append(
                "<thead><tr>"
                + "".join(f"<{tag}>{inline(c)}</{tag}>" for c in cells)
                + "</tr></thead><tbody>"
            )
        else:
            bodies.append(
                "<tr>" + "".join(f"<{tag}>{inline(c)}</{tag}>" for c in cells) + "</tr>"
            )
    return "<table>" + "".join(bodies) + "</tbody></table>"


def md_to_html(src: str) -> str:
    lines = src.replace("\r\n", "\n").split("\n")
    out: list[str] = []
    i = 0
    in_code = False
    code_lang = ""
    code_buf: list[str] = []
    para: list[str] = []
    list_kind = None
    table_rows: list[str] = []

    def flush_para() -> None:
        nonlocal para
        if para:
            out.append("<p>" + inline(" ".join(para)) + "</p>")
            para = []

    def flush_list() -> None:
        nonlocal list_kind
        if list_kind:
            out.append(f"</{list_kind}>")
            list_kind = None

    def flush_table() -> None:
        nonlocal table_rows
        if table_rows:
            out.append(render_table(table_rows))
            table_rows = []

    while i < len(lines):
        line = lines[i]
        if in_code:
            if line.startswith("```"):
                out.append(
                    f'<pre><code class="language-{html.escape(code_lang)}">'
                    f"{html.escape(chr(10).join(code_buf))}</code></pre>"
                )
                in_code = False
                code_buf = []
            else:
                code_buf.append(line)
            i += 1
            continue
        if line.startswith("```"):
            flush_para()
            flush_list()
            flush_table()
            in_code = True
            code_lang = line[3:].strip()
            i += 1
            continue
        if re.match(r"^\s*\|.*\|\s*$", line) and "|" in line:
            flush_para()
            flush_list()
            table_rows.append(line)
            i += 1
            continue
        if table_rows:
            flush_table()
        if re.match(r"^#{1,6} ", line):
            flush_para()
            flush_list()
            hashes, rest = line.split(" ", 1)
            level = min(len(hashes), 6)
            out.append(f"<h{level}>{inline(rest.strip())}</h{level}>")
            i += 1
            continue
        if re.match(r"^---+\s*$", line) or re.match(r"^\*\*\*+\s*$", line):
            flush_para()
            flush_list()
            out.append("<hr>")
            i += 1
            continue
        ul = re.match(r"^(\s*)[-*] (.+)$", line)
        ol = re.match(r"^(\s*)\d+\. (.+)$", line)
        if ul or ol:
            flush_para()
            kind = "ul" if ul else "ol"
            text = (ul or ol).group(2)
            if list_kind != kind:
                flush_list()
                list_kind = kind
                out.append(f"<{kind}>")
            out.append(f"<li>{inline(text)}</li>")
            i += 1
            continue
        if list_kind and not line.strip():
            flush_list()
            i += 1
            continue
        if line.startswith("> "):
            flush_para()
            flush_list()
            out.append(f"<blockquote><p>{inline(line[2:])}</p></blockquote>")
            i += 1
            continue
        if not line.strip():
            flush_para()
            flush_list()
            i += 1
            continue
        para.append(line.strip())
        i += 1
    flush_para()
    flush_list()
    flush_table()
    if in_code:
        out.append(f"<pre><code>{html.escape(chr(10).join(code_buf))}</code></pre>")
    return "\n".join(out)


def parse_nav() -> str:
    summary = (WIKI / "SUMMARY.md").read_text(encoding="utf-8")
    items = []
    for line in summary.splitlines():
        m = re.match(r"^(\s*)\* \[([^\]]+)\]\(([^)]+)\)", line)
        if not m:
            continue
        indent, label, href = m.groups()
        depth = len(indent) // 2
        items.append(
            f'<a class="nav-link depth-{depth}" href="{html.escape(md_href_to_html(href))}">'
            f"{html.escape(label)}</a>"
        )
    return "\n".join(items)


PAGE = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title} · OrderEasy help</title>
<style>
:root {{ color-scheme: light; --bg:#f7f5f2; --fg:#1c1917; --muted:#57534e; --card:#fff; --accent:#b45309; --line:#e7e5e4; }}
* {{ box-sizing: border-box; }}
body {{ margin:0; font: 16px/1.55 ui-sans-serif, system-ui, sans-serif; background:var(--bg); color:var(--fg); }}
.layout {{ display:grid; grid-template-columns: 280px 1fr; min-height:100vh; }}
nav {{ background:#1c1917; color:#fafaf9; padding:1.25rem 1rem 2rem; overflow:auto; }}
nav h1 {{ font-size:1rem; margin:0 0 .25rem; }}
nav p {{ color:#a8a29e; font-size:.8rem; margin:0 0 1rem; }}
.nav-link {{ display:block; color:#e7e5e4; text-decoration:none; padding:.28rem .5rem; border-radius:6px; font-size:.9rem; }}
.nav-link:hover, .nav-link.active {{ background:#292524; color:#fff; }}
.depth-0 {{ font-weight:600; margin-top:.55rem; }}
.banner {{ background:#fff7ed; border:1px solid #fdba74; color:#9a3412; padding:.65rem 1rem; font-size:.9rem; }}
.banner a {{ color:#9a3412; }}
main {{ padding:1.5rem 2rem 3rem; max-width: 880px; }}
article {{ background:var(--card); border:1px solid var(--line); border-radius:12px; padding:1.5rem 1.75rem; }}
h1,h2,h3 {{ line-height:1.25; }}
h1 {{ margin-top:0; }}
a {{ color:var(--accent); }}
code {{ background:#f5f5f4; padding:.1rem .3rem; border-radius:4px; font-size:.9em; }}
pre {{ background:#1c1917; color:#fafaf9; padding:1rem; border-radius:8px; overflow:auto; }}
pre code {{ background:transparent; color:inherit; padding:0; }}
table {{ border-collapse:collapse; width:100%; margin:1rem 0; font-size:.95rem; }}
th,td {{ border:1px solid var(--line); padding:.45rem .6rem; text-align:left; }}
th {{ background:#fafaf9; }}
blockquote {{ border-left:3px solid var(--accent); margin:1rem 0; padding:.2rem 0 .2rem 1rem; color:var(--muted); }}
hr {{ border:0; border-top:1px solid var(--line); }}
@media (max-width: 860px) {{
  .layout {{ grid-template-columns: 1fr; }}
  nav {{ max-height: 40vh; }}
}}
</style>
</head>
<body>
<div class="banner">Canonical Git wiki on <code>RetailerCustomerPlatform</code> <code>main</code> is still August 2026.
Land via <a href="https://github.com/vin8003/RetailerCustomerPlatform/issues/137">issue 137</a> (KAN-275). This Pages site is a preview, not the lasting edit.</div>
<div class="layout">
<nav>
<h1>OrderEasy help</h1>
<p>18 Sep 2026 preview</p>
{nav}
</nav>
<main><article>
{body}
</article></main>
</div>
</body>
</html>
"""


def out_path_for(md_path: Path) -> Path:
    rel = md_path.relative_to(WIKI)
    if rel.name == "README.md":
        return OUT / rel.parent / "index.html"
    return OUT / rel.with_suffix(".html")


def title_of(md: str, fallback: str) -> str:
    for line in md.splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return fallback


def main() -> None:
    if OUT.exists():
        for p in OUT.rglob("*"):
            if p.is_file():
                p.unlink()
    nav = parse_nav()
    files = sorted(WIKI.rglob("*.md"))
    if not files:
        raise SystemExit(f"no markdown under {WIKI}")
    for md_path in files:
        text = md_path.read_text(encoding="utf-8")
        dest = out_path_for(md_path)
        dest.parent.mkdir(parents=True, exist_ok=True)
        title = title_of(text, md_path.stem)
        dest.write_text(
            PAGE.format(title=html.escape(title), nav=nav, body=md_to_html(text)),
            encoding="utf-8",
        )
        print(f"wrote {dest.relative_to(OUT)}")
    print(f"built {len(files)} pages -> {OUT}")


if __name__ == "__main__":
    main()
