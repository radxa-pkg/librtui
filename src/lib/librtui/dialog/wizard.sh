#!/usr/bin/env bash

wizard_init() {
	__parameter_count_check 0 "$@"

	export RTUI_WIZARD_SELECTED_INDEX=0
}

wizard_call() {
	__parameter_count_check 1 "$@"

	if [[ -z $RTUI_WIZARD_SELECTED_INDEX ]]; then
		if ! menu_call "$@"; then
			if menu_is_cancelled; then
				wizard_set_complete
			fi
		else
			RTUI_WIZARD_SELECTED_INDEX=$((RTUI_MENU_SELECTED_INDEX))
		fi

		return
	fi

	RTUI_MENU_SELECTED="$(menu_getitem "$RTUI_WIZARD_SELECTED_INDEX")"
	RTUI_MENU_SELECTED_INDEX="$RTUI_WIZARD_SELECTED_INDEX"
	if ! ${RTUI_MENU_CALLBACK[$RTUI_WIZARD_SELECTED_INDEX]}; then
		RTUI_WIZARD_SELECTED_INDEX=
	fi
}

wizard_is_complete() {
	__parameter_count_check 0 "$@"

	if [[ -n $RTUI_WIZARD_SELECTED_INDEX ]]; then
		RTUI_WIZARD_SELECTED_INDEX=$((RTUI_WIZARD_SELECTED_INDEX + 1))
		((RTUI_WIZARD_SELECTED_INDEX >= ${#RTUI_MENU_CALLBACK[@]}))
	else
		return 1
	fi
}

wizard_set_complete() {
	__parameter_count_check 0 "$@"

	RTUI_WIZARD_SELECTED_INDEX=${#RTUI_MENU_CALLBACK[@]}
}
