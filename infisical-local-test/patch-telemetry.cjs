const fs = require('node:fs');

function replaceOnce(path, before, after) {
  const source = fs.readFileSync(path, 'utf8');
  const first = source.indexOf(before);
  if (first < 0 || source.indexOf(before, first + before.length) >= 0) {
    throw new Error(`Expected exactly one telemetry patch location in ${path}`);
  }
  fs.writeFileSync(path, source.slice(0, first) + after + source.slice(first + before.length));
}

const dist = '/backend/dist';

// Product analytics and signup event transports.
const telemetryService = `${dist}/services/telemetry/telemetry-service.mjs`;
replaceOnce(
  telemetryService,
  `const postHog = appCfg.TELEMETRY_ENABLED ? new PostHog(appCfg.POSTHOG_PROJECT_API_KEY, {
    host: appCfg.POSTHOG_HOST,
    maxQueueSize: TELEMETRY_POSTHOG_MAX_QUEUE_SIZE
  }) : void 0;`,
  'const postHog = void 0;'
);
replaceOnce(telemetryService, 'if (appCfg.isProductionMode && appCfg.LOOPS_API_KEY) {', 'if (false) {');
replaceOnce(
  telemetryService,
  'if (appCfg.isProductionMode && instanceType === InstanceType.Cloud && appCfg.HUBSPOT_PORTAL_ID && appCfg.HUBSPOT_SIGNUP_FORM_ID) {',
  'if (false) {'
);

const telemetryQueue = `${dist}/services/telemetry/telemetry-queue.mjs`;
replaceOnce(
  telemetryQueue,
  'const postHog = appCfg.isProductionMode && appCfg.TELEMETRY_ENABLED ? new PostHog(appCfg.POSTHOG_PROJECT_API_KEY, { host: appCfg.POSTHOG_HOST, flushAt: 1, flushInterval: 0 }) : void 0;',
  'const postHog = void 0;'
);

// The browser reads this runtime script before loading the application bundle.
const serveUi = `${dist}/server/plugins/serve-ui.mjs`;
replaceOnce(serveUi, 'POSTHOG_API_KEY: appCfg.POSTHOG_PROJECT_API_KEY,', 'POSTHOG_API_KEY: "",');
replaceOnce(serveUi, 'INTERCOM_ID: appCfg.INTERCOM_ID,', 'INTERCOM_ID: "",');
replaceOnce(serveUi, 'TELEMETRY_CAPTURING_ENABLED: appCfg.TELEMETRY_ENABLED,', 'TELEMETRY_CAPTURING_ENABLED: false,');

// License usage snapshots must stay local even if a key is later configured.
const usageReporter = `${dist}/services/license-client/usage/usage-reporter.mjs`;
replaceOnce(
  usageReporter,
  'reportSnapshots: /* @__PURE__ */ __name(async (orgId, snapshots) => {',
  'reportSnapshots: /* @__PURE__ */ __name(async (orgId, snapshots) => {\n    return;'
);
replaceOnce(
  usageReporter,
  'var buildUsageReporter = /* @__PURE__ */ __name((envConfig) => {',
  'var buildUsageReporter = /* @__PURE__ */ __name((envConfig) => {\n  return null;'
);

// Optional metrics/traces and version checks are separate outbound paths.
replaceOnce(`${dist}/lib/telemetry/instrumentation.mjs`, 'void setupTelemetry();', 'void 0;');
replaceOnce(
  `${dist}/services/update-check/update-check-fns.mjs`,
  'var isUpdateCheckEnabled = /* @__PURE__ */ __name((input) => !input.isInfisicalCloud && !input.isCloud && !input.isUpdateCheckDisabled && !input.hasOfflineLicense && Boolean(parseSemanticVersion(input.platformVersion)), "isUpdateCheckEnabled");',
  'var isUpdateCheckEnabled = /* @__PURE__ */ __name((_input) => false, "isUpdateCheckEnabled");'
);
