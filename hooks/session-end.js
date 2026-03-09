#!/usr/bin/env node
// Session End — Stop hook
// Saves a lightweight session summary when Claude stops, regardless of
// whether context was critical or the user just typed /exit.
//
// Only writes if no recent handoff already exists (avoids duplicate saves
// when context-monitor already triggered the CRITICAL handoff).
//
// The summary is written to ~/.claude/orchestrator/last-session.md and
// picked up by session-start.sh on the next session.

const fs = require('fs');
const os = require('os');
const path = require('path');

const HANDOFF_PATH = path.join(
  os.homedir(), '.claude', 'orchestrator', 'last-session.md'
);
const HANDOFF_MAX_AGE_SECONDS = 300; // 5 min — skip if recent handoff exists

let input = '';
const stdinTimeout = setTimeout(() => process.exit(0), 3000);
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
  clearTimeout(stdinTimeout);
  try {
    const data = JSON.parse(input);

    // If a recent handoff file already exists (written by context-monitor
    // at CRITICAL), don't overwrite it — it has richer context.
    if (fs.existsSync(HANDOFF_PATH)) {
      const now = Math.floor(Date.now() / 1000);
      let fileMtime;
      try {
        fileMtime = Math.floor(fs.statSync(HANDOFF_PATH).mtimeMs / 1000);
      } catch (e) {
        fileMtime = 0;
      }
      if ((now - fileMtime) < HANDOFF_MAX_AGE_SECONDS) {
        // Recent handoff exists, skip
        process.exit(0);
      }
    }

    // Ensure the orchestrator directory exists
    const dir = path.dirname(HANDOFF_PATH);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    // Tell Claude to write a session summary before stopping.
    // This is injected as additionalContext so Claude executes it
    // as part of its final response.
    const message =
      'SESSION ENDING — Before stopping, write a brief session summary to ' +
      HANDOFF_PATH + ' with:\n' +
      '- **Date:** today\n' +
      '- **Task:** what you were working on\n' +
      '- **Status:** current progress\n' +
      '- **Next step:** what to do next\n\n' +
      'Keep it concise (5-10 lines). Only write if there was meaningful work this session.';

    process.stdout.write(JSON.stringify({
      hookSpecificOutput: {
        hookEventName: 'Stop',
        additionalContext: message
      }
    }));
  } catch (e) {
    process.exit(0);
  }
});
