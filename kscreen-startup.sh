#!/bin/zsh

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <width> <hight> <fps>"
    exit 2
fi

# Dummy plug output name
DUMMY="HDMI-A-1"

unset restore_e_params
unset restore_d_params
unset output_list

/usr/bin/kscreen-doctor -j | jq -c '.outputs[]' | while read -r repo;
do
  ENABLED=$(echo "$repo" | jq -r '.enabled')
  OUTPUT_NAME=$(echo "$repo" | jq -r '.name')
  CURRENT_MODE=$(echo "$repo" | jq -r '.currentModeId')
  SCALE=$(echo "$repo" | jq -r '.scale')

  if [[ "$OUTPUT_NAME" != "$DUMMY" ]]; then
    output_list+=("output.$OUTPUT_NAME.disable")
  fi
  if [ "$ENABLED" = "true" ]; then
    restore_e_params+=("output.$OUTPUT_NAME.enable")
    restore_e_params+=("output.$OUTPUT_NAME.mode.$CURRENT_MODE")
    restore_e_params+=("output.$OUTPUT_NAME.scale.$SCALE")
  else
    restore_d_params+=("output.$OUTPUT_NAME.disable")
  fi
done

cat > $(pwd)/kscreen-restore.sh <<- EOM
#!/bin/sh
/usr/bin/kscreen-doctor $restore_e_params $restore_d_params
EOM

/usr/bin/kscreen-doctor output.$DUMMY.enable output.$DUMMY.mode.$1x$2@$3 $output_list
