# Sentinel Metrics

[![GitHub release](https://img.shields.io/github/release/olliveirajr/sentinel-metrics.svg)](https://GitHub.com/olliveirajr/sentinel-metrics/releases/)
[![GitHub license](https://img.shields.io/github/license/olliveirajr/sentinel-metrics.svg)](https://github.com/olliveirajr/sentinel-metrics/blob/main/LICENSE)
![GitHub repo size](https://img.shields.io/github/repo-size/olliveirajr/sentinel-metrics.svg)

O sentinel metrics é uma stack de monitoramento e métricas de aplicações. Ele é capaz de coletar métricas de diversas fontes, como aplicações, servidores, bancos de dados, etc. Além disso, ele é capaz de armazenar essas métricas e disponibilizá-las para visualização em dashboards.

## Arquitetura

O sentinel metrics é composto por 8 componentes principais:

- **Node Exporter**: é o responsável por coletar as métricas de uma determinada fonte e disponibilizá-las para o Prometheus. Ele é executado no mesmo host que a aplicação que se deseja monitorar.
- **Cadvisor**: é o responsável por coletar métricas de containers Docker.
- **Promtail**: é o responsável por coletar logs e enviá-los para o Loki.
- **Loki**: é o responsável por armazenar os logs coletados pelo Promtail.
- **Prometheus**: é o responsável por coletar as métricas dos Node Exporters e armazená-las. Ele também é responsável por disponibilizar essas métricas para visualização em dashboards.
- **Blackbox Exporter**: é o responsável por coletar métricas de serviços externos, como APIs, websites, etc.
- **Alertmanager**: é o responsável por gerenciar alertas. Ele é capaz de receber alertas do Prometheus e enviá-los para diferentes canais, como Slack, Email, etc.
- - **Grafana**: é a ferramenta de visualização de métricas. Ela é responsável por se conectar ao Prometheus e exibir as métricas em dashboards.
