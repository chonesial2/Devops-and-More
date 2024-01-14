
FROM python:3.9 as builder

RUN pip3 install --no-cache-dir poetry  \
    && poetry config virtualenvs.create false

# Install python dependenccies using poetry
WORKDIR /app
COPY pyproject.toml pyproject.toml
RUN  poetry install

COPY . .
RUN make --directory=/app/docs/ html

FROM nginx:alpine

COPY --from=builder /app/docs/_build/html /usr/share/nginx/html
EXPOSE 80
