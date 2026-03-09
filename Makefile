.PHONY: tag push-tags

tag:
	@if [ -z "$(word 2,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please provide a tag name (e.g., make tag common-ci-js/v1.0.7)"; \
		exit 1; \
	fi
	$(eval TAG_NAME := $(word 2,$(MAKECMDGOALS)))
	$(eval WORKFLOW_NAME := $(shell echo $(TAG_NAME) | cut -d'/' -f1))
	@if [ ! -f ".github/workflows/$(WORKFLOW_NAME).yml" ]; then \
		echo "Error: Workflow file '.github/workflows/$(WORKFLOW_NAME).yml' not found"; \
		exit 1; \
	fi
	@echo "Creating tag: $(TAG_NAME)"
	git tag $(TAG_NAME)
	$(eval MAJOR_TAG := $(shell echo $(TAG_NAME) | sed -E 's/^(.*\/v[0-9]+)\.[0-9]+\.[0-9]+$$/\1/'))
	@echo "Force updating major version tag: $(MAJOR_TAG)"
	git tag -f $(MAJOR_TAG)
	@echo "Tags created successfully"

%:
	@:

push-tags:
	@echo "Syncing tags with remote..."
	@REMOTE_TAGS=$$(git --no-pager ls-remote --tags origin | grep -v '\^{}' | awk '{print $$2 " " $$1}' | sed 's|refs/tags/||'); \
	OUTDATED_TAGS=""; \
	git tag -l | while read tag; do \
		local_sha=$$(git rev-list -n 1 "$$tag"); \
		remote_sha=$$(echo "$$REMOTE_TAGS" | awk -v t="$$tag" '$$1 == t {print $$2}'); \
		if [ -n "$$remote_sha" ] && [ "$$local_sha" != "$$remote_sha" ]; then \
			echo "Force pushing outdated tag: $$tag"; \
			git push -f origin "$$tag"; \
		elif [ -z "$$remote_sha" ]; then \
			echo "Pushing new tag: $$tag"; \
			git push origin "$$tag"; \
		fi; \
	done
	@echo "All tags have been synced"
