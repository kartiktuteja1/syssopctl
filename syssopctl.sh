#!/bin/bash

VERSION="v0.1.0"

function show_help() {
    cat << EOF
Usage: sysopctl [OPTIONS] [COMMAND]

Manage system resources and tasks.

Options:
  --help             Show this help message
  --version          Show version information

Commands:
  service list       List all running services
  service start <name> Start a specific service
  service stop <name>  Stop a specific service
  system load        Display system load averages
  disk usage         Display disk usage statistics
  process monitor    Monitor system processes
  logs analyze       Analyze recent critical system logs
  backup <path>      Backup files from a specified path
EOF
}

function show_version() {
  echo "sysopctl version $VERSION"
}

function list_services() {
  systemctl list-units --type=service
}

function manage_service() {
  if [[ $1 == "start" ]]; then
    systemctl start "$2"
    echo "Service $2 started."
  elif [[ $1 == "stop" ]]; then
    systemctl stop "$2"
    echo "Service $2 stopped."
  else
    echo "Invalid service operation. Use 'start' or 'stop'."
  fi
}

function system_load() {
  uptime
}

function disk_usage() {
  df -h
}

function process_monitor() {
  top
}

function analyze_logs() {
  journalctl -p crit
}

function backup_files() {
  rsync -av --progress "$1" /backup/
  echo "Backup completed for $1."
}

case "$1" in
  --help)
    show_help
    ;;
  --version)
    show_version
    ;;
  service)
    case "$2" in
      list)
        list_services
        ;;
      start|stop)
        manage_service "$2" "$3"
        ;;
      *)
        echo "Invalid service command. Use 'list', 'start <name>', or 'stop <name>'."
        ;;
    esac
    ;;
  system)
    if [[ $2 == "load" ]]; then
      system_load
    else
      echo "Invalid system command. Use 'load'."
    fi
    ;;
  disk)
    if [[ $2 == "usage" ]]; then
      disk_usage
    else
      echo "Invalid disk command. Use 'usage'."
    fi
    ;;
  process)
    if [[ $2 == "monitor" ]]; then
      process_monitor
    else
      echo "Invalid process command. Use 'monitor'."
    fi
    ;;
  logs)
    if [[ $2 == "analyze" ]]; then
      analyze_logs
    else
      echo "Invalid logs command. Use 'analyze'."
    fi
    ;;
  backup)
    if [[ -n $2 ]]; then
      backup_files "$2"
    else
      echo "Please provide a path to backup."
    fi
    ;;
  *)
    echo "Invalid command. Use --help for usage information."
    ;;
esac

