.PHONY : clean test
clean:
	rm -f .state.mc

create:
	mcloud create project --name new
	mcloud create network --name net1 --project new

test: create clean

