# Refactoring

Going back to the ALB example, we can see that main.tf contains a provider, a few variables, resources, some data, and outputs. It is common to put these in separate files. A common best practices is to put resources, outputs and variables in separate files. This is what has been done in `alb_refactored`.

This example also goes one step further in cleaning up the code by converting the ALB example into a module. All the code used to create the web application is now in the `webapp` module, making the code easier to read and maintain.

There are some other things we can do to make the `webapp` module a little more reusable. For example, it would be nice to be able to configure the number of servers in the ASG. It can also be useful to make the AMI ID configurable at the top-level `vars.tf`.

When using variables with modules, you need to define the variable within the module and  alsoat the top-level if it is to be configurable from the command-line.

The `alb_modules_and_input_variables` adds an input variable called `server_count` and hard-codes the `image_id`. If you run `terraform apply`, you'll now be prompted to specify the value of `server_count`. If you need to change the image_id at some point, you can just change it in the top-level vars.tf. 