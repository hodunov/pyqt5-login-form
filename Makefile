# ************************************************
# ***************** uv ***************************
# ************************************************

.PHONY: compile  # compile base dependencies
pip-compile:
	python -m uv pip compile ./requirements/base.in -v --upgrade -o ./requirements/base.txt

.PONY: sync  # sync base dependencies
pip-sync:
	python -m uv pip sync ./requirements/base.txt
