ip=$(curl -s http://checkip.amazonaws.com)

dsp_sec_group_names=(
  1_dev-analytics
  2_tst-analytics
  4_qas-analytics
  5_prd-analytics
)

dup_sec_group_names=(
  dup-qas
  dup-prd
)


ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
description='ssh van gils'
TAG_KEY=source
TAG_VALUE=gvgils-script

add_rules () {
  profile=$1
  shift
  names=("${@}")

  sec_groups=()

  echo Getting group IDs...
  for sec_group_name in "${names[@]}"
  do
    GROUP_ID=$(aws ec2 describe-security-groups \
      --filter Name=group-name,Values=$sec_group_name \
      --profile $profile | jq -r .SecurityGroups[0].GroupId)

    sec_groups+=($GROUP_ID)
  done

  printf "Removing existing, and adding new rules...\n"

  for sec_group in "${sec_groups[@]}"
  do
    # To not keep many unused rules in the group, remove the previous one by tag (from creating it via this script)
    EXISTING_RULE=$(aws ec2 describe-security-group-rules \
      --filters Name=group-id,Values=${sec_group} Name=tag:${TAG_KEY},Values=${TAG_VALUE} \
      --profile $profile | jq  -r .SecurityGroupRules[0].SecurityGroupRuleId)

    if [ ! -z "$EXISTING_RULE" -a $EXISTING_RULE != "null" ]; then
      if aws ec2 revoke-security-group-ingress \
      --group-id $sec_group \
      --security-group-rule-ids $EXISTING_RULE \
      --profile $profile >> /dev/null;
        then
          :
      else 
        printf "${ORANGE}Did not manage to remove $EXISTING_RULE from $sec_group for mijnaansluiting with the above error${NC}\n"
      fi
    fi

    if aws ec2 authorize-security-group-ingress \
      --group-id $sec_group \
      --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$ip/32,Description='$description'}]" \
      --tag-specifications "ResourceType=security-group-rule,Tags=[{Key=$TAG_KEY,Value=$TAG_VALUE}]" \
      --profile $profile >> /dev/null ;   # on success, don't show anything, if failed, this will still show the error
      then
        :
    else
      printf "${ORANGE}Did not manage to add $ip to $sec_group for $profile with the above error${NC}\n"
    fi

  done

  printf "${GREEN}Successfully added rules for $profile${NC}\n\n";
}

printf "Adding current ip (${ip}) to AWS security groups\n"



add_rules dsp "${dsp_sec_group_names[@]}"
add_rules dup "${dup_sec_group_names[@]}"
