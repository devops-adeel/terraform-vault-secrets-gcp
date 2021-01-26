# Contributing

This document provides guidelines for contributing to the module.

## Dependencies

The following dependencies must be installed on the development system:

- [Terraform CLI](https://www.terraform.io/downloads.html)
- [Inspec](https://docs.chef.io/inspec/install/)
- [Terraform Docs](https://github.com/terraform-docs/terraform-docs)

## Generating Documentation for Inputs and Outputs

The Inputs and Outputs tables in the READMEs of the root module,
submodules, and example modules are automatically generated based on
the `variables` and `outputs` of the respective modules. These tables
must be refreshed if the module interfaces are changed.

### Execution

Run `terraform-docs markdown >> README.md` to generate new Inputs and Outputs tables.

## Commit Messages and Changelog updates.

Please ensure the Changelog is updated with merge to main branch. Changes not git-tagged should be under `[unreleased]`.

Please use sane commit messages following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

## Integration Testing

Integration tests are used to verify the behaviour of the root module,
submodules, and example modules. Additions, changes, and fixes should
be accompanied with tests.

The integration tests are run using [Kitchen][kitchen],
[Kitchen-Terraform][kitchen-terraform], and [InSpec][inspec].

The general strategy for these tests is to verify the behaviour of the
[example modules](./examples/), thus ensuring that the root module,
submodules, and example modules are all functionally correct.

### Test Environment
The easiest way to test the module is in an isolated test TFE workspace. The setup for such a project is defined in [test/setup](./test/setup/) directory.


### Noninteractive Execution

Run `make docker_test_integration` to test all of the example modules
noninteractively, using the prepared test project.

### Interactive Execution

1. Run `make docker_run` to start the testing Docker container in
   interactive mode.

1. Run `kitchen_do create <EXAMPLE_NAME>` to initialize the working
   directory for an example module.

1. Run `kitchen_do converge <EXAMPLE_NAME>` to apply the example module.

1. Run `kitchen_do verify <EXAMPLE_NAME>` to test the example module.

1. Run `kitchen_do destroy <EXAMPLE_NAME>` to destroy the example module
   state.

## Linting and Formatting

Many of the files in the repository can be linted or formatted to
maintain a standard of quality.

### Execution

Run `make docker_test_lint`.

[inspec]: https://inspec.io/
[kitchen-terraform]: https://github.com/newcontext-oss/kitchen-terraform
[kitchen]: https://kitchen.ci/
[shellcheck]: https://www.shellcheck.net/
[terraform-docs]: https://github.com/segmentio/terraform-docs
[terraform]: https://terraform.io/
