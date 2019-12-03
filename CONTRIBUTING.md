Thanks for working to make the `JSONAPI` framework better for everyone!

## Issues
Please create an Issue for any new bug you find or any new feature you would like to see in the future. If you are also able to work on the issue yourself, reference the issue by URL from the description of your PR. 

In the issue, 
1. Describe both the expected behavior and the current (buggy) behavior of the library. 
2. Specify the version of the framework you are using.
3. Specify the platform you are running the framework on (i.e. Linux, Mac OS, iOS, etc.).
4. Give any information you can about the code you've written that uses the framework or the API requests/responses you are attempting to pass through the framework unsuccessfully.
5. Drop a note if you intend to fix the issue so no one else duplicates your effort in the meantime!

## Pull Requests
Please try to create Issues prior to creating Pull Requests. In the body of your Pull Request description, mention the issue the PR addresses by URL.

For all code additions, add tests that cover the new code. If you are fixing a bug, include at least 1 test case that would have failed prior to your fix but succeeds now that you have fixed the bug. This is important to avoid regressions in the future.

Before creating the pull request, make sure all tests are passing and run `swift test --generate-linuxmain` to generate the test files for running in Linux environments.
