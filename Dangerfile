# The Dangerfile contains a collection of home-grown rules specific to your project.
# http://danger.systems/

# Warn about incomplete PR title.
warn("Please add a more descriptive title.") if github.pr_title.length < 10

# Warn about incomplete PR description.
warn("Please add a detailed summary in the description.") if github.pr_body.length < 10

# Warn about large PR!
warn("This PR is too big! Consider breaking it down into smaller PRs.") if git.lines_of_code > 2000
