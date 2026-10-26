param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FlutterArgs
)

$flutterRoot = "$env:USERPROFILE\flutter"
$env:FLUTTER_ROOT = $flutterRoot
$env:FLUTTER_ALREADY_LOCKED = "true"
$env:CI = "true"
$dart = "$flutterRoot\bin\cache\dart-sdk\bin\dart.exe"
$pkg = "$flutterRoot\packages\flutter_tools\.dart_tool\package_config.json"
$runner = "$PSScriptRoot\flutter_runner.dart"

& $dart --packages=$pkg $runner @FlutterArgs
