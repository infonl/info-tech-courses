IMAGE ?= itc-sandbox

.PHONY: help sandbox shell test test-in-sandbox preview render

help:
	@echo "make sandbox          build the student sandbox image"
	@echo "make shell            open a shell in the sandbox, repo mounted at /workspace"
	@echo "make test             smoke-test all course exercises + NL/EN command check"
	@echo "make test-in-sandbox  same, inside the sandbox image (what CI does)"
	@echo "make preview          live-preview the site with Quarto"
	@echo "make render           render the site into _site/"

sandbox:
	docker build -t $(IMAGE) sandbox

shell: sandbox
	docker run --rm -it -v "$(CURDIR)":/workspace $(IMAGE)

test:
	COURSES="$(CURDIR)" bash tools/ready.sh
	@set -e; for c in courses/*/; do \
	  if [ -f "$$c/exercises/check.sh" ]; then tools/run-exercises.sh "$$c"; fi; \
	done
	tools/check-translations.sh

test-in-sandbox: sandbox
	docker run --rm -v "$(CURDIR)":/workspace $(IMAGE) make test

preview:
	quarto preview

render:
	quarto render
