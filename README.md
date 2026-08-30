# Supervisord Docker Implementation

## Outline

This implementation allows for easy extension. It implements `entrypoint.d` and `healthcheck.d` so children images can add that to the stack easily.

### Entrypoint.D

The primary entrypoint implements the execution of all files in `/entrypoint.d` (folder created in the Dockerfile).

Simply add child image's entrypoint to `/entrypoint.d` with correct sequence number. Take note that entrypoints get executed in ascending order of the number prefix you give it.

### HealthCheck.D

Similar to entrypoint.d mechism, except it implements healthchecks located in `/healthcheck.d`. Same idea, be aware of numerical prefix you give the file, they execute in order.

