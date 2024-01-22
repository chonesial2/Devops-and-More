#!/bin/bash

ACTION=$1
FILENAME=$2
NAMESPACE_FLAG=$3
NAMESPACE=$4

show_help() {
  echo -e "\nUsage: "
  echo -e "  $0 [action] [values_file] [-n <namespace>] "
  echo -e "\nManage helm release on kubernetes cluster. "
  echo -e "\nParametes: "
  echo -e "  action           : (Required) Install/upgarde/uninstall helm release on/from kubernetes cluster "
  echo -e "  values_file      : (Required) Name of the helm values file "
  echo -e "  -n <namespace>   : (Optional) Define namespace to manage the helm release "
  echo -e "\nExamples: "
  echo -e "  $0 install values.yaml "
  echo -e "  $0 upgrade values.yaml -n example-namespace"
  echo -e "\n"
}

validate_args() {
  # Action should be one of install, upgrade or uninstall
  if ! { [ "$ACTION" == "install" ] || [ "$ACTION" == "upgrade" ] || [ "$ACTION" == "uninstall" ]; }; then
      echo "ERROR: Action should be one of 'install', 'upgrade' or 'uninstall'! "
      show_help; exit 1
  fi

  # Check helm values file
  if ! [ "$FILENAME" ]; then
    echo "ERROR: 'values_file' is missing! "
    show_help; exit 1
  fi

  if ! [ -f "$FILENAME" ]; then
      echo "ERROR: values_file '$FILENAME' does not exist! "
      show_help; exit 1
  fi

  # Check namespace flag and namespace
  if [ "$NAMESPACE_FLAG" ]; then
    if [ "$NAMESPACE_FLAG" != "-n" ]; then
      echo "ERROR: use '-n' to pass namespaces parameter! "
      show_help; exit 1
    fi

    # Namespace should be supplied
    if ! [ "$NAMESPACE" ]; then
      echo "ERROR: 'namespace' is missing! "
      show_help; exit 1
    fi
  fi

}

create_chart() {

cat << EOF > Chart.yaml
apiVersion: v2
name: $app_name
description: $description
type: $app_type
version: $chart_version
appVersion: $app_version

EOF

}


build_helm_cmd() {
  helm_release="$project_name-$app_name"
  if ! [ "$NAMESPACE" ]; then
    namespace="$project_name-$app_env"
  else
    namespace="$NAMESPACE"
  fi

  helm_cmd="helm upgrade $helm_release ./ -f $FILENAME -n $namespace --install"
  if [ "$ACTION" == "uninstall" ]; then
    helm_cmd="helm uninstall $helm_release -n $namespace"
  fi

  # Print the helm command
  echo "Helm Command: "
  echo "  $helm_cmd"
}

#------------------------------------------------------------------------------------------------
# Start of helm install script
#------------------------------------------------------------------------------------------------

# Run validation on arguments
validate_args;

# Parse helm values file
echo "Parsing $FILENAME... "
app_info=$(yq .app $FILENAME)
project_name=$(echo $app_info | yq .projectName | tr -d '"')
app_name=$(echo $app_info | yq .appName | tr -d '"' )
description=$(echo $app_info | yq .description | tr -d '"' )
app_type=$(echo $app_info | yq .type | tr -d '"' )
chart_version=$(echo $app_info | yq .version | tr -d '"' )
app_version=$(echo $app_info | yq .appVersion | tr -d '"' )
app_env=$(echo $app_info | yq .environment | tr -d '"' )

echo "App details: "
echo "  Project Name  : $project_name"
echo "  App Name      : $app_name"
echo "  Description   : $description"
echo "  Type          : $app_type"
echo "  Chart Version : $chart_version"
echo "  App Version   : $app_version"
echo "  Environment   : $app_env"

# Create Chart.yaml file
if [ "$ACTION" == "install" ] || [ "$ACTION" == "upgrade" ]; then
  create_chart;
fi

# Build helm command
build_helm_cmd;
