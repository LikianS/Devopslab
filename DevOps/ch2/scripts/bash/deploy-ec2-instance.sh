#!/usr/bin/env bash
set -e

# Variable pour définir le nombre d'instances
COUNT=2

# Récupération du script user-data
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Attention: Assure-toi que user-data.sh existe bien dans le même dossier
if [ -f "$SCRIPT_DIR/user-data.sh" ]; then
    user_data=$(cat "$SCRIPT_DIR/user-data.sh")
else
    echo "⚠️ Attention: user-data.sh introuvable, lancement sans script de démarrage."
    user_data=""
fi

# 1. Création du Security Group (avec un nom unique pour éviter les erreurs si on relance)
SG_NAME="sample-app-$(date +%s)"
echo "Création du Security Group: $SG_NAME..."

security_group_id=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "Allow HTTP traffic into the sample app" \
    --output text \
    --query GroupId)

# 2. Ajout de la règle port 80 (ou 8080 selon ton app)
aws ec2 authorize-security-group-ingress \
    --group-id "$security_group_id" \
    --protocol tcp \
    --port 80 \
    --cidr "0.0.0.0/0" > /dev/null

# 3. Lancement des instances MULTIPLES
echo "Lancement de $COUNT instances..."

# Note le changement : --count $COUNT et la query Instances[*]
instance_ids=$(aws ec2 run-instances \
    --image-id "ami-0900fe555666598a2" \
    --instance-type "t3.micro" \
    --security-group-ids "$security_group_id" \
    --user-data "$user_data" \
    --count "$COUNT" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=sample-app}]' \
    --output text \
    --query 'Instances[*].InstanceId')

echo "Instances lancées : $instance_ids"

# 4. Attente (La commande wait accepte plusieurs IDs séparés par des espaces)
echo "En attente du démarrage..."
aws ec2 wait instance-running --instance-ids $instance_ids

# 5. Récupération des IPs publiques
public_ips=$(aws ec2 describe-instances \
    --instance-ids $instance_ids \
    --output text \
    --query 'Reservations[*].Instances[*].PublicIpAddress')

echo "------------------------------------------------"
echo "DEPLOYMENT COMPLETE"
echo "Instance IDs    = $instance_ids"
echo "Security Group  = $security_group_id"
echo "Public IPs      = $public_ips"
echo "------------------------------------------------"
