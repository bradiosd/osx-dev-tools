---
applyTo: "**"
---

# mw-payments-sim Development Guidelines

## Running Services

**IMPORTANT: DO NOT start or restart services automatically. Always assume services are already running.**

### mw-payments
- **Port**: 9100
- **Start command**: `npm run dev` or `npm start` (user manages this)
- **Hot-reloading**: Yes, uses nodemon with TypeScript compilation
- **Build command**: `npm run build` (compiles TypeScript to `dist/` directory)
- **Location**: `/Users/brad/Code/motorway/mw-payments`
- **Note**: Never run `npm run dev` - user starts/stops this service manually

### mw-payments-sim (Remix Mock Service)
- **Port**: 3001 (auto-selects if 3000 is in use)
- **Start command**: `npm run dev` (user manages this)
- **Hot-reloading**: Yes, Remix dev server watches for file changes
- **Location**: `/Users/brad/Code/motorway/mobilize-improvements/apps/mw-payments-sim`
- **Note**: Never run `npm run dev` - user starts/stops this service manually

## Important Hot-Reloading Notes

### Remix Route Hot-Reloading
- Remix automatically picks up changes to route files when they're modified
- **Critical**: If you create a NEW route file, Remix may not recognize it until you:
  1. Make a small edit to the file (triggering hot-reload), OR
  2. Restart the dev server
- Existing route modifications hot-reload immediately

### mw-payments Hot-Reloading
- Uses nodemon with TypeScript compilation
- Watches for file changes in the `app/` directory
- Automatically rebuilds and restarts on changes
- **Note**: Changes to `node_modules` are NOT watched and require manual restart

### Environment Variable Changes
- Both apps use dotenv for environment variables
- Changes to `.env` files require a restart to take effect
- mw-payments uses `dotenv-defaults`:
  - Loads `.env.defaults` first (committed to git, contains default values)
  - Then loads `.env` to override defaults (gitignored, contains local overrides)

## Configuration

### mw-payments-sim Environment Variables
```bash
PORT=3001
MW_PAYMENTS_SIM_URL=http://localhost:3001
JWT_SECRET=testJwtSecret
MOCK_SCENARIO=partner-mobilize
```

### mw-payments Environment Variables
Key variables for mock service integration:
```bash
GATEWAY_API=http://localhost:3001/gateway/
JWT_SECRET=testJwtSecret
```

## Mock Service Architecture

### Gateway Endpoints
- `GET /gateway/providers/:service` - Returns service credentials
- `GET /gateway/vars` - Returns config vars (empty object)

### Composer Endpoints
- `GET /enquiries/:id` - Returns mock enquiry data with configurable partner field

### Mock Scenarios
Available scenarios (set via `MOCK_SCENARIO` env var):
- `partner-mobilize` - Partner: Mobilize, tests partner blocking logic
- `non-partner` - No partner set, should allow payments
- `partner-other` - Partner: OtherPartner, for other partner testing
- `custom` - Customizable scenario

## Debugging Tips

### Viewing Service Logs

#### mw-payments Logs
```bash
# If running in Docker
docker logs mw-payments -f

# If running directly with npm
# Logs appear in the terminal where you ran npm run dev
```

#### mw-payments-sim Logs
```bash
# View live logs in terminal where npm run dev is running

# Or check the log file (last 50 lines)
cat /Users/brad/Code/motorway/mobilize-improvements/apps/mw-payments-sim/logs/dev.log

# Tail the log file
tail -f /Users/brad/Code/motorway/mobilize-improvements/apps/mw-payments-sim/logs/dev.log
```

### Verify Services Are Running
```bash
# Check if mw-payments is running
lsof -i :9100

# Check if mw-payments-sim is running
lsof -i :3001
```

### Test Mock Endpoints Directly
```bash
# Test gateway endpoint
curl -u "mw-payments:local-dev-password" "http://localhost:3001/gateway/providers/mw-dealership-composer"

# Test enquiry endpoint (requires JWT token)
curl -H "x-mway-user: <JWT_TOKEN>" "http://localhost:3001/enquiries/1"
```

### Common Issues
1. **404 errors from gateway**: Remix route file not loaded - trigger hot-reload by editing the file
2. **Connection refused**: Service not running or wrong port
3. **401 Unauthorized**: JWT secret mismatch between apps
4. **Environment variable not loaded**: Need to restart service after changing .env

## Development Workflow

### Making Changes to mw-payments-sim
1. Edit route files or configuration
2. Check terminal for hot-reload confirmation
3. If new routes don't work, make a small edit to trigger reload
4. Test endpoints with curl or via mw-payments

### Making Changes to mw-payments
1. Edit TypeScript files in `app/` directory
2. Watch terminal for rebuild/restart
3. Wait for "listening on port 9100" message
4. Test via mw-cli or direct API calls

### Testing Partner Payment Logic
1. Set `MOCK_SCENARIO` in mw-payments-sim `.env`
2. User will restart mw-payments-sim manually if needed
3. Generate JWT token with appropriate partner field
4. Submit create post sale offer request
5. Verify expected blocking/allowing behavior

## Common Commands

```bash
# Kill process on specific port
lsof -ti:9100 | xargs kill -9

# Rebuild mw-payments
npm run build

# View environment variables
cat .env | grep GATEWAY_API

# Check JWT secret matches
cat .env | grep JWT_SECRET
```
