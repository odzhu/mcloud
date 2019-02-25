.PHONY : clean test
clean:
	rm -f .state.mc

create:
	mcloud create project --name new
	mcloud create network --name net1 --project new

test: create clean

adminzone:
	cd tf/admin &&\
	pwd &&\
	terraform init &&\
	terraform apply

helminit:
	cd tf/helminit &&\
	terraform init && terraform apply

rancher:
	cd tf/rancher &&\
	terraform init && terraform apply

destroy:
	cd tf/rancher &&\
	terraform destroy -auto-approve

cleanstate:
	rm -f tf/*tfstate.* &&\
	rm -f tf/admin/*tfstate.* &&\
	rm -f tf/helm_init/*tfstate.* &&\
	rm -f tf/rancher/*tfstate.*
