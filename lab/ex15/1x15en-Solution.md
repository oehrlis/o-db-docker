## Solution 15: Container Monitoring

The following steps are performed in this exercise:

- configure and review HEALTHCHECK
- Setup and configure Prometheus
- Setup and configure Grafana.

<!-- Stuff between the <div class="notes"> will be rendered as pptx slide notes -->
<div class="notes">
</div>

<!-- Stuff between the <div class="no notes"> will not be rendered as pptx slide notes -->
<div class="no notes">

### Docker HEALTHCHECK

During the `docker build` a HEALTHCHECK script has been specified. This script is execute on a regular basis. The result is visible vi `docker ps`

```bash
docker ps
```

Alternatively it is also possible to see the resource used by the container

```bash
docker stats eusoud
```

### Prometheus

Prometheus will not be set up as part of the DOAG Training Day. See [getting started](https://prometheus.io/docs/prometheus/latest/getting_started/)

### Grafana

Grafana will not be set up as part of the DOAG Training Day. See [getting started](https://grafana.com/docs/guides/getting_started/)
</div>
