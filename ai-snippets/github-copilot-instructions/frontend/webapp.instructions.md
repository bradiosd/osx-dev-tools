---
applyTo: 'apps/webapp/**'
---

# Webapp Rules

## Webapp API Request Authentication

### Checklist for New API Requests

- [ ] Does this page/component make API calls to protected endpoints?
- [ ] If yes, am I using `useAxiosAuth` instead of `apiClient`?
- [ ] Have I checked that the `user` exists before making authenticated requests?
- [ ] Are all `GET`, `POST`, `PUT`, `DELETE` calls using the `axiosAuth` instance?
- [ ] Add tests 
