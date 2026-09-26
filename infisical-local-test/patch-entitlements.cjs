const fs = require('node:fs');

function replaceOnce(path, before, after) {
  const source = fs.readFileSync(path, 'utf8');
  const first = source.indexOf(before);
  if (first < 0 || source.indexOf(before, first + before.length) >= 0) {
    throw new Error(`Expected exactly one patch location in ${path}`);
  }
  fs.writeFileSync(path, source.slice(0, first) + after + source.slice(first + before.length));
}

const licenseFns = '/backend/dist/ee/services/license/license-fns.mjs';
const insertionPoint = 'var getEnforcedIdentityLimit =';
const entitlementOverride = `const getOriginalDefaultOnPremFeatures = getDefaultOnPremFeatures;
getDefaultOnPremFeatures = () => {
  const plan = getOriginalDefaultOnPremFeatures();
  for (const [key, value] of Object.entries(plan)) {
    if (value === false) plan[key] = true;
  }
  plan.slug = "enterprise";
  plan.pam = true;
  plan.certManager = true;
  plan.secretsTemporaryAccess = true;
  plan.enterprisePamAccount = true;
  plan.auditLogsRetentionDays = 3650;
  plan.auditLogStreamLimit = 1000;
  plan.honeyTokenLimit = 1000000;
  plan.maxCas = null;
  plan.rateLimits = { readLimit: 1000000, writeLimit: 1000000, secretsLimit: 1000000 };
  return plan;
};
${insertionPoint}`;
replaceOnce(licenseFns, insertionPoint, entitlementOverride);

const licenseService = '/backend/dist/ee/services/license/license-service.mjs';
replaceOnce(
  licenseService,
  'let instanceType = InstanceType.OnPrem;',
  'let instanceType = InstanceType.EnterpriseOnPrem;'
);
replaceOnce(
  licenseService,
  'if (instanceType === InstanceType.EnterpriseOnPrem) {\n      await licenseClient?.refreshEntitlements',
  'if (instanceType === InstanceType.EnterpriseOnPrem && licenseKeyConfig.isValid) {\n      await licenseClient?.refreshEntitlements'
);
