import json

d = json.load(open('dynamic_peps.json'))

for g in d['sigGroupList']:
    print('### {0}'.format(g['groupName']))
    print('<table>')
    for f in g['sigList']:
        params = ""
        for p in f["paramList"]:
            params += "<br/>{0} {1}".format(p["paramType"], p["paramName"])
        params = params[5:]
        print("<tr><td>pep_{0}_pre</td><td>{1}</td></tr>".format(f["funcName"],params))
        print("<tr><td>pep_{0}_post</td><td>{1}</td></tr>".format(f["funcName"],params))
    print('</table>')

print('### microservices')
print('<table>')
print('<tr><td colspan="2">Microservice plugins are not wrapped with dynamic policy enforcement points.</td></tr>')
print('</table>')
