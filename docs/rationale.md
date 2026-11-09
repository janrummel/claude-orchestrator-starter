# Why the rules are shaped the way they are

Every rule in this kit costs something. This page says what each one costs, what
it buys, and when you should break it. If you disagree with a rule after reading
its reason, break it on purpose, that is a better outcome than following it
without knowing why.

## Memory is one fact per file, with a pointer-only index

**Cost:** many small files instead of one document you can scroll.

**Why:** a memory file gets read by a model that has room for a handful of them,
not for all of them. One fact per file means the index can decide relevance from
a one-line description and load only what matters. A single long memory document
forces an all-or-nothing choice, and in practice it rots: nobody deletes a
paragraph in the middle of a file they otherwise still need.

The index holds pointers only for the same reason a library catalogue does not
contain the books.

**Break it when:** two facts genuinely cannot be understood apart. Then they are
one fact, and one file is right.

## Project state lives in the project, not in memory

**Cost:** the state is not in one central place you can review at a glance.

**Why:** this is the rule with the clearest failure mode behind it. If a status
lives in two places, both will be edited and they will disagree, and you will not
find out until one of them sends you the wrong way. Keeping status in the project
and only a pointer in memory makes disagreement structurally impossible.

The second reason is portability, which is the point of this whole kit: a folder
that carries its own state can be continued by any model, on any harness, with no
external memory system at all.

**Break it when:** never, in our experience. Copy the pointer, not the status.

## `STATE.md` starts with exactly ONE next action

**Cost:** it feels wrong to reduce a rich project to a single line.

**Why:** a list of five next actions is a list of zero next actions, because the
first thing anyone does with it is decide which one to do, and that decision is
the expensive part. Naming one action forces the prioritisation while you still
have the context, instead of leaving it to a future session that has none.

If you cannot name one action, that is the state: write "blocked on X" and what
would unblock it. That sentence is more useful than five plausible tasks.

## At most three projects count as active

**Cost:** you have to demote projects you still care about.

**Why:** three is not a magic number and it was not measured; it is chosen from
experience as the point where switching cost starts eating the gain, for one person doing knowledge work
alongside a job. What makes the rule work is not the number but the definition:
**active means forward pressure or a deadline.** Everything else gets an explicit
category, finishing, personal, infrastructure, or paused with a concrete
re-trigger, and does not count.

The failure this prevents has a name: keeping something "active" that has no
forward pressure. That is drift wearing the costume of ambition, and it is
invisible without a limit that forces the question.

**Break it when:** your categories are honest and you still need four. Then raise
the number deliberately and write down why. Raising it silently is the failure.

## Every session ends with one closure decision

**Cost:** a few minutes at the end of a session that felt finished.

**Why:** work accumulates faster than it concludes, and the natural end of a
session is "we made progress", which closes nothing. Requiring one decision,
adopt, park, close, or archive, means the portfolio shrinks at least as often as
it grows. Parking with a concrete re-trigger is a real closure; parking with
"later" is not.

## The agent may only write to two vault folders

**Cost:** you have to promote notes yourself instead of letting the agent file
them.

**Why:** an agent with write access to a whole knowledge vault will, over months,
quietly restructure it around its own conventions. Not maliciously; just steadily.
Then the vault belongs to the tool. Two zones, an inbox for capture and a gallery
for finished pieces, let the agent feed the vault while you stay the curator.

This is also the rule most likely to be enforced rather than requested if your
harness can do it, because it is the one where a mistake is expensive and
gradual, which is the worst combination for a rule that relies on discipline.

**Break it when:** you are willing to be the person who reviews every write.

## Clarify before Produce, always

**Cost:** the first minutes of a session produce no output.

**Why:** the stated question is frequently not the real problem, and an agent is
very good at answering the stated question well. Fast. In depth. The cost of a
well-argued answer to the wrong question is not just the wasted work, it is that
it looks like progress.

See [`../examples/first-session.md`](../examples/first-session.md) for a worked
case where "should we switch tools" turned out to be "concurrent edits are lost".

## Rules are requested unless a harness enforces them

**Cost:** honesty here makes the kit look weaker than kits that stay quiet.

**Why:** because the alternative is worse. A rule you believe is enforced, but
isn't, is more dangerous than a rule you know is only requested, you calibrate
your trust to the belief, not to the reality. Two lessons from auditing our own
setup drive this: the existence of a rule is not its effectiveness, and a guard
should only be believed after you have seen it fire.

[`portability.md`](portability.md) is the map. Read it before trusting a chain of
outputs.
