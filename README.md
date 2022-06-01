# publish-pacts
Composite action to publish pact files to pact broker

**When would you use it?**

When you want to publish your pact files to pact broker using a github composite action

## Arguments

| Argument Name                                  | Required | Default | Description                                                                         | Allowed              |
|------------------------------------------------|----------|---------|-------------------------------------------------------------------------------------|----------------------|
| `pact_file_dir`                                | True     | N/A     | Pacts file path                                                                     |                      |
| `consumer_app_version`                         | True     | N/A     | The consumer application version                                                    |                      |
| `tag`                                          | True     | N/A     | Tag name for consumer version. Can be specified multiple times                      |                      |
| `repository_branch`                            | False    | N/A     | Repository branch of the consumer version                                           |                      |
| `tag_with_git_branch`                          | True     | false   | Tag consumer version with the name of the current git branch                        | **true**, **false**  |
| `merge`                                        | True     | false   | If a pact already exists for this consumer version and provider, merge the contents | **true**, **false**  |
| `broker_base_url`                              | True     | N/A     | Pact_Broker/Pact_Flow  base url                                                     |                      |
| `broker_username`                              | False    | N/A     | Pact Broker basic auth username                                                     |                      |
| `broker_password`                              | False    | N/A     | Pact Broker basic auth password                                                     |                      |
| `broker_token`                                 | False    | N/A     | Pact Broker bearer token                                                            |                      |
| `build_url`                                    | False    | N/A     | The build URL that created the pact                                                 |                      |

## Example

### Publish pacts with all required parameters

```yaml
- uses: rajnavakotiikea/publish-pacts@v1.0.1
  with:
    pact_file_dir: ${PWD}/pacts
    consumer_app_version: ${{ github.sha }}
    tag: ${{ github.ref_name }}
    broker_base_url: pact_broker_base_url
    broker_token: pact_broker_token
```

### Publish pacts with all possible parameters

```yaml
- uses: rajnavakotiikea/publish-pacts@v1.0.1
  with:
    pact_file_dir: ${PWD}/pacts
    consumer_app_version: ${{ github.sha }}
    tag: ${{ github.ref_name }}
    broker_base_url: pact_broker_base_url
    broker_token: pact_broker_token
    repository_branch: ${{ github.ref_name }}
    merge: true
    tag_with_git_branch: true
```