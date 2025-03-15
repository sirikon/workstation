FROM debian:bookworm-slim
WORKDIR /wd
RUN apt-get update && apt-get install -y ncdu
COPY . .
CMD ["ncdu"]
