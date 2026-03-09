#!/usr/bin/env node
// Context Monitor — PostToolUse hook
// Reads context metrics from the bridge file (written by context-statusline.js)
// and injects warnings when context usage is high.
//
// Thresholds:
//   WARNING  (remaining <= 45%): Wrap up current task (~55% used)
//   CRITICAL (remaining <= 35%): Save session state for seamless handoff (~65% used)
//
// At CRITICAL, Claude is instructed to write a handoff file so the next
// session (via claude-loop + session-start.sh) can pick up seamlessly.
//
// Debounce: 5 tool uses between warnings to avoid spam.

const fs = require('fs');
const os = require('os');
const path = require('path');

const WARNING_THRESHOLD = 45;
const CRITICAL_THRESHOLD = 35;
const STALE_SECONDS = 60;
const DEBOUNCE_CALLS = 5;

const HANDOFF_PATH = path.join(
  os.homedir(), '.claude', 'orchestrator', 'last-session.md'
);

let input = '';
const stdinTimeout = setTimeout(() => process.exit(0), 3000);
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
  clearTimeout(stdinTimeout);
  try {
    const data = JSON.parse(input);
    const sessionId = data.session_id;
    if (!sessionId) process.exit(0);

    const tmpDir = os.tmpdir();
    const metricsPath = path.join(tmpDir, `claude-ctx-${sessionId}.json`);

    if (!fs.existsSync(metricsPath)) process.exit(0);

    const metrics = JSON.parse(fs.readFileSync(metricsPath, 'utf8'));
    const now = Math.floor(Date.now() / 1000);

    // Ignore stale metrics
    if (metrics.timestamp && (now - metrics.timestamp) > STALE_SECONDS) process.exit(0);

    const remaining = metrics.remaining_percentage;
    const usedPct = metrics.used_pct;

    // No warning needed
    if (remaining > WARNING_THRESHOLD) process.exit(0);

    // --- Debounce logic ---
    const warnPath = path.join(tmpDir, `claude-ctx-${sessionId}-warned.json`);
    let warnData = { callsSinceWarn: 0, lastLevel: null };
    let firstWarn = true;

    if (fs.existsSync(warnPath)) {
      try {
        warnData = JSON.parse(fs.readFileSync(warnPath, 'utf8'));
        firstWarn = false;
      } catch (e) { /* reset on parse error */ }
    }

    warnData.callsSinceWarn = (warnData.callsSinceWarn || 0) + 1;

    const isCritical = remaining <= CRITICAL_THRESHOLD;
    const currentLevel = isCritical ? 'critical' : 'warning';

    // Severity escalation bypasses debounce
    const severityEscalated = currentLevel === 'critical' && warnData.lastLevel === 'warning';
    if (!firstWarn && warnData.callsSinceWarn < DEBOUNCE_CALLS && !severityEscalated) {
      fs.writeFileSync(warnPath, JSON.stringify(warnData));
      process.exit(0);
    }

    // Reset debounce counter
    warnData.callsSinceWarn = 0;
    warnData.lastLevel = currentLevel;
    fs.writeFileSync(warnPath, JSON.stringify(warnData));

    // --- Build message ---
    let message;
    if (isCritical) {
      message =
        `CONTEXT CRITICAL: ${usedPct}% used, ${remaining}% remaining.\n` +
        'MANDATORY — before doing anything else:\n' +
        `1. Write a session handoff to ${HANDOFF_PATH} with this format:\n` +
        '   # Session Handoff\n' +
        '   - **Date:** [today]\n' +
        '   - **Task:** [what you were working on]\n' +
        '   - **Status:** [current progress]\n' +
        '   - **Key decisions:** [decisions made this session]\n' +
        '   - **Next step:** [exact next action]\n' +
        '   - **Open questions:** [anything unresolved]\n' +
        '   - **Key files:** [relevant file paths]\n' +
        '2. Also update the active project file if one exists.\n' +
        '3. Tell the user: context is nearly full, state has been saved, ' +
        'they can start a new session and it will pick up where we left off.';
    } else {
      message =
        `CONTEXT WARNING: ${usedPct}% used, ${remaining}% remaining. ` +
        'Context is getting low. Finish the current task, do not start complex new tasks. ' +
        'Inform the user at the next opportunity.';
    }

    process.stdout.write(JSON.stringify({
      hookSpecificOutput: {
        hookEventName: 'PostToolUse',
        additionalContext: message
      }
    }));
  } catch (e) {
    process.exit(0);
  }
});
