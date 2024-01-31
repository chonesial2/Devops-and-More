# StackExpress Docs

## Getting started

- [Install poetry](https://python-poetry.org/docs/#osx--linux--bashonwindows-install-instructions)

```bash

python3 -m pip install --user poetry
```

- Install dependencies

```bash

poetry install
```

- Build them to see how they look

```
cd docs/
make html
```

- The `index.rst` has been built into `index.html` in your documentation output directory (typically `_build/html/index.html`). Open this file in your web browser to see your docs.


