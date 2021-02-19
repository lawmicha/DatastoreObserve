##

Issue: https://github.com/aws-amplify/amplify-flutter/issues/395

Schema from: https://github.com/kjones/datastore_test/blob/main/amplify/backend/api/datastoretest/schema.graphql



## Project set up

1. `amplify init`

2. `amplify add api` and select conflict resolution, `schema.graphql` when prompted

3. `amplify codegen models`

**Note** did not run `amplify push` since I am only testing local only.

4. `pod install --repo-update` and `xed .`