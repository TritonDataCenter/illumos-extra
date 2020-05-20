import sys
results = {}
buf = ''
fname = ''
for line in sys.stdin:
    if line.startswith('---'):
        if buf:
            if buf in results:
                results[buf].extend([fname])
            else:
                results[buf] = [fname]
        buf = ''
        fname = line.split(' ')[1]
    elif line.startswith('+++'):
        pass
    elif line.startswith('@@'):
        if buf:
            if buf in results:
                results[buf].extend([fname])
            else:
                results[buf] = [fname]
        buf = ''
    else:
        buf += line

for key in results.iterkeys():
    print "From %s" % ', '.join(results[key])
    print "="*68
    print '   %s' % '\n   '.join(key.splitlines())
    print
