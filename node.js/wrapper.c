#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <err.h>
#include <errno.h>
#include <string.h>

static const struct subst {
	const char *s_in;
	const char *s_out;
} stbl[] = {
	{
		.s_in = "-lsunw_crypto",
		.s_out = "-lcrypto"
	},
	{
		.s_in = "-lsunw_ssl",
		.s_out = "-lssl"
	}
};

static const uint_t n_substs = sizeof (stbl) / sizeof (stbl[0]);

int
main(int argc, char *argv[])
{
	const char **nargv;
	uint_t i, j;

	if (argc < 2)
		err(-1, "Usage: %s <compiler> <arguments...>", argv[0]);

	if ((nargv = malloc(argc * sizeof (char *))) == NULL)
		err(-1, "malloc");

	nargv[0] = argv[1];

	for (i = 2; i < (uint_t)argc; i++) {
		nargv[i - 1] = argv[i];
		for (j = 0; j < n_substs; j++) {
			if (strcmp(argv[i], stbl[j].s_in) == 0) {
				nargv[i - 1] = stbl[j].s_out;
				break;
			}
		}
	}

	nargv[argc - 1] = NULL;

	if (execvp(nargv[0], (char **)nargv) != 0)
		err(-1, "failed to exec %s", nargv[0]);

	_exit(0);
}
