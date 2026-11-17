# topic_reminder.ps1 - UserPromptSubmit hook. Enforces the topic table of
# _session/kit/core.md ("Which Topic File When"): when the prompt touches a
# topic, the assistant is reminded to read that topic file before it acts.
# Prints nothing when no topic matches. Never fails, never blocks.
# Keywords: English and German. A project that needs its own words (names of
# customers, products, tools) copies this script into its own tools/hooks/
# folder and edits the table there; the kit copy holds no project words.

$ErrorActionPreference = 'SilentlyContinue'
$prompt = ''
try {
    $raw = [Console]::In.ReadToEnd()
    if ($raw) { $prompt = [string](($raw | ConvertFrom-Json).prompt) }
} catch { }
if (-not $prompt) { exit 0 }

$topics = @(
    @{ File = 'tasks.md';     Words = 'task|aufgabe|finding|gap|journal|timetable' },
    @{ File = 'working.md';   Words = 'plan\b|proposal|vorschlag|discuss|decision|entscheid' },
    @{ File = 'facts.md';     Words = 'number|zahl|source|quelle|price|preis|datasheet|measure|messung' },
    @{ File = 'capture.md';   Words = 'screenshot|picture|photo|foto|image|bild|attachment|anhang|\.msg|mail|log\b' },
    @{ File = 'files.md';     Words = 'script|\.ps1|\.py|rename|folder|ordner|new file|neue datei' },
    @{ File = 'git.md';       Words = 'commit|push|pull|branch|merge|rebase|\bgit\b|stage' },
    @{ File = 'debugging.md'; Words = 'bug|crash|hang|fault|stack trace|debug|fehler' },
    @{ File = 'testing.md';   Words = '\btest|release check|regress' },
    @{ File = 'hardware.md';  Words = 'flash|bench|wiring|serial|com\d|stecker|plug|batterie|battery|erase|nvs' },
    @{ File = 'release.md';   Words = 'release|ship|package|paket|transfer|versand' },
    @{ File = 'messages.md';  Words = 'mail|outlook|draft|entwurf|forum|chat|customer|kunde' }
)

$hit = @()
foreach ($t in $topics) {
    if ($prompt -match $t.Words) { $hit += $t.File }
}
if ($hit.Count -eq 0) { exit 0 }

Write-Output ("TOPIC REMINDER (core.md table): this prompt touches: " + ($hit -join ', ') + ". If baseline.md lists them as active and you have not read them in this session, read _session/kit/rules/<file> before you act.")
if ($prompt -match 'mail|outlook|\.msg') {
    Write-Output "Mail: no take-over of the mail client or the mailbox without asking and waiting for the OK (core.md Hard Rule 4)."
}
if ($prompt -match 'commit|push|pull') {
    Write-Output "Git: no git add, commit, push or pull without the user's word in this message (core.md Hard Rule 1)."
}
exit 0
