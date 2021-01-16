{ config, lib, ... }:
with lib;
let cfg = config.services.flowercluster.monitoring;
in {
  options = {
    services.flowercluster.monitoring.enable = mkEnableOption "monitoring";
  };

  config = mkIf cfg.enable {
    # enable grafana with default settings
    services.grafana.enable = true;

    # enable prometheus with node exporter
    services.prometheus.enable = true;
    services.prometheus.exporters.node.enable = true;

    # scrape node exporter
    services.prometheus.scrapeConfigs = [
      {
        job_name = "node_scraper";
        static_configs = [{
          targets = [
            "${
              toString config.services.prometheus.exporters.node.listenAddress
            }:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
      {
        job_name = "wakatime";
        static_configs = [{ targets = [ "0.0.0.0:9212" ]; }];
      }
    ];
  };
}
