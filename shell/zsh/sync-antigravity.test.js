const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('node:path');
const fs = require('node:fs');
const os = require('node:os');

const { syncMcp, syncSkills } = require('./.sync-antigravity.js');

test('sync-antigravity module exports syncMcp and syncSkills functions', () => {
  assert.equal(typeof syncMcp, 'function');
  assert.equal(typeof syncSkills, 'function');
});

test('syncMcp handles missing source settings gracefully', () => {
  // Save original homedir if needed, run syncMcp
  const result = syncMcp();
  assert.ok(result);
  assert.ok('skipped' in result || 'results' in result);
});

test('syncSkills executes and returns status result object', () => {
  const result = syncSkills();
  assert.ok(result);
  assert.ok('skipped' in result || 'results' in result);
});
