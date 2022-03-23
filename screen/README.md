# Updating the tar

Generally we download the tar directly from https://ftp.gnu.org/gnu/screen/
For the 4.9.0 release, they didn't run `autogen.sh` to generate the
`configure` script before creating the tar so it's missing there.
The `configure` script is required for our build system, so for the
4.9.0 release I've unpacked the tar, run `autogen.sh`, removed the
`autom4te` cache then `diff`d it to create a patch that will drop
in a valid `configure` script.

Hopefully they'll rectify this in the future. But if not, when you
update the tar you'll have to delete the existing patch and perform
this again so that it's up to date with new version.

Run `git log` on this file for a list of attrocities committed here.
