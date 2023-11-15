#

iRODS source code is currently stored and managed in git repositories, and our 'upstream'
repositories are currently hosted at github.com.

All contributions to iRODS Consortium code are subject to its existing BSD-3 License.

[https://docs.github.com/en/github/site-policy/github-terms-of-service#6-contributions-under-repository-license](https://docs.github.com/en/github/site-policy/github-terms-of-service#6-contributions-under-repository-license)



The current best practice for contributing changes to iRODS is as follows:

1. Fork the iRODS repository of interest into your own github.com namespace

    The main iRODS server code is at irods/irods, but many other plugins and clients are also in the irods/ namespace.

2. Create a branch to do your work

    Our convention has become to name the branch of the form 'issue.branch[.description]'.
The name of the branch will be public, but once merged, will not be part of the record of the upstream repository.

3. Add new commits to your branch of your fork

    Each unit of new work should be encapsulated in a single commit.  Each new enhancement or bug fix
should come with a test that exercises the new code (and demonstrates a bug was trapped).  The
commit message should begin with "[XXXX] " and include the issue number this commit addresses.  Do not
include the # sign with the commit message, yet.  This will be included later - we do not want the
issue in question to be populated with activity messages during code review.  The
rest of the commit message should have a single line that explains what was done.  If more explanation
is necessary or helpful, it should be included in the remainder of a multiline commit message.

    If this is a cross-repository commit message (meaning, you are working in a repository but referring to
an issue in a different repository), then begin the commit message with "[irods/repository_XXXX] ".  This
will correctly link the commit to the issue in question once the # sign is added.

4. Create a pull request to the correct upstream branch

    When local development is ready for some review from others, push your local branch to your fork
at github.com.  On the github.com website, create a pull request to the appropriate upstream branch.
Name the pull request with a suffix of " (main)" or " (4-3-stable)" to help the reviewers distinguish
between similar pull requests to different branches (in the case of cherry-picks).

5. Go through code review

    The team and community will provide comments and other feedback.  Automated tools (static analysis, etc.)
may also provide feedback that should be taken into consideration.  Add comments and commits to address
all feedback.

    - Add more commits
    - Resolve questions

6. Clean up pull request for merge

    When the code review has completed and the pull request is ready to be cleaned up for merge, rebase and
squash the commits down to the ones that should be part of the public timeline.  Once this has been
agreed to via comments and discussion, add the # sign to the commit messages (which will leave a notification
on those issues). Then, force push your cleaned branch, which will automatically update the existing pull request.

    - Rebase
    - Squash
    - Add #
    - Force push

7. Wait for pull request to be merged

    The maintainer of the upstream repository will merge your pull request.

8. Checkbox and close any completed issues

    After the pull request is merged, you can delete your branch (both locally and in your fork at github.com).
Then, attend to any checkboxes and issues that may need to be closed.  If you do not have edit rights to the
checkboxes, ask someone with rights to complete this step.  This bookkeeping is important when release notes are
compiled and statistics are generated for posterity.  Issues in closed milestones are never reopened.

