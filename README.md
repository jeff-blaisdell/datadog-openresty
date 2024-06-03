# datadog-openresty

## Description
Provides a reproducible test case of building OpenResty w/ DataDog's Nginx module showing how it's incompatible with
current Ubuntu LTS versions.

## Steps To Reproduce
1. cd into the `./openresty` folder and run the `./build-openresty.sh` script.  This will build an OpenResty distribution
   from scratch targeting the desired Ubuntu flavor and any additional modules (like DataDogs) needed.
2. cd into the `./openresty-test` folder and run `./build-openresty-test.sh`.  This create a new image derived from the
   the former image containing additional dependencies to launch a test harness.
3. From the `./openresty-test` folder run the following command to launch a shell into the test container.
   ```
    docker run -v $(pwd)/t/:/opt/t --rm -it --entrypoint bash jblaisdell/openresty-test:latest
   ```
4. From inside the test container run:
   ```
   prove t/datadog.t
   ```
   This uses the Perl based Test::Nginx test harness OpenResty uses to verifying its own builds.  See [OpenResty - Testing](https://openresty.gitbooks.io/programming-openresty/content/testing/)
   for more details.

   Note - upon running prove command the OpenResty test harness will create a directory in the local project called `sevroot`.  
   This contains more details from the nginx process that was launched / ran the test including the error.log.

# Result
Above test fails stating DataDog module requires GLIBC_2.36.
```
nginx: [emerg] dlopen() "/usr/local/openresty/nginx/modules/ngx_http_datadog_module.so" failed (/lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.36' not found (required by /usr/local/openresty/nginx/modules/ngx_http_datadog_module.so)) in /opt/t/servroot/conf/nginx.conf:16
```

Running `ldd --version ldd` on the Jammy image shows Ubuntu has GLIBC:
```ldd (Ubuntu GLIBC 2.35-0ubuntu3.7) 2.35```

Running `lsb_release -a` confirms the details of the Ubuntu environment.
```
Distributor ID:	Ubuntu
Description:	Ubuntu 22.04.4 LTS
Release:	22.04
Codename:	jammy
```