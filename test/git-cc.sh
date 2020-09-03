#!/usr/bin/env bash

testSwitchUnknown() {
  first_line=$(. ./git-cc -t 2>&1 | head -1)
  assertEquals "error: unknown switch \`-t'" "${first_line}"
}

testOptionUnknown() {
  first_line=$(. ./git-cc --test 2>&1 | head -1)
  assertEquals "error: unknown option \`--test'" "${first_line}"
}

testMissingSubject() {
  first_line=$(. ./git-cc 2>&1 | head -1)
  assertEquals "fatal: subject must be provided" "${first_line}"
}

testSwitchH() {
  first_line=$(. ./git-cc -h 2>&1 | head -1)
  assertEquals "usage: git cc --subject <subject>" "${first_line}"
}

testOptionHelp() {
  first_line=$(. ./git-cc --help 2>&1 | head -1)
  assertEquals "usage: git cc --subject <subject>" "${first_line}"
}

testOptionDryRun() {
  commit_msg=$(. ./git-cc --dry-run --subject 'some text')
  assertEquals "chore: some text" "${commit_msg}"
}

testOptionType() {
  commit_msg=$(. ./git-cc --subject 'subject description' --type 'test' --dry-run)
  assertEquals "test: subject description" "${commit_msg}"
}

testOptionScope() {
  commit_msg=$(. ./git-cc --subject 'subject description' --scope 'test' --dry-run)
  assertEquals "chore(test): subject description" "${commit_msg}"
}

testOptionSubject() {
  commit_msg=$(. ./git-cc --subject 'some description' --dry-run)
  assertEquals "chore: some description" "${commit_msg}"
}

testOptionBody() {
  commit_msg=$(. ./git-cc --subject 'some description' --body 'long description' --dry-run | head -3 | tail -1)
  assertEquals "long description" "${commit_msg}"
}

testOptionBreaking() {
  commit_msg=$(. ./git-cc --subject 'some description' --breaking 'breaking description' --dry-run | head -3 | tail -1)
  assertEquals "BREAKING CHANGE: breaking description" "${commit_msg}"
}

. /usr/local/bin/shunit2
