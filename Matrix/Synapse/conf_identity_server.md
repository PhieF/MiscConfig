Identitity servers are useful to make a link between your phone number / mail and your matrix account


to enable it you need to set a public_baseurl which is basically you matrix server url

```
public_baseurl: https://blabla
```

then enable identities servers
```
account_threepid_delegates:
    msisdn: https://vector.im
trusted_third_party_id_servers:
    - matrix.org
    - vector.im
```

these are the one provided by matrix.org, I didn't set my own
