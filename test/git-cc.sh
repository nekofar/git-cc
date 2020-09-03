#!/usr/bin/env bash

oneTimeSetUp() {
  shopt -s expand_aliases
  alias git-cc='${PWD}/git-cc'
}

testSwitchUnknown() {
  [ "${BASH_VERSINFO[0]}" -lt 4 ] && startSkipping

  result=$(git-cc -t 2>&1 | head -1)
  expect='error: unknown switch `-t'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result%?}'"
}

testOptionUnknown() {
  [ "${BASH_VERSINFO[0]}" -lt 4 ] && startSkipping

  result=$(git-cc --test 2>&1 | head -1)
  expect='error: unknown option `--test'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result%?}'"
}

testMissingSubject() {
  [ "${BASH_VERSINFO[0]}" -lt 4 ] && startSkipping

  result=$(git-cc 2>&1 | head -1)
  expect='fatal: subject must be provided'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testSwitchH() {
  [ "${BASH_VERSINFO[0]}" -lt 4 ] && startSkipping

  result=$(git-cc -h 2>&1 | head -1)
  expect='usage: git cc --subject <subject>'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionHelp() {
  [ "${BASH_VERSINFO[0]}" -lt 4 ] && startSkipping

  result=$(git-cc --help 2>&1 | head -1)
  expect='usage: git cc --subject <subject>'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionDryRun() {
  result=$(git-cc --dry-run --subject 'some text')
  expect='chore: some text'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionType() {
  result=$(git-cc --subject 'subject description' --type 'test' --dry-run)
  expect='test: subject description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionScope() {
  result=$(git-cc --subject 'subject description' --scope 'test' --dry-run)
  expect='chore(test): subject description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionSubject() {
  result=$(git-cc --subject 'some description' --dry-run)
  expect='chore: some description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionBody() {
  result=$(git-cc --subject 'some description' --body 'long description' --dry-run | head -3 | tail -1)
  expect='long description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionBreaking() {
  result=$(git-cc --subject 'some description' --breaking 'breaking description' --dry-run | head -3 | tail -1)
  expect='BREAKING CHANGE: breaking description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

testOptionInteractive() {
  result=$(echo -e "test\nunit\nsome description\n\n\n" | git-cc --interactive --dry-run)
  expect='test(unit): some description'
  ${_ASSERT_EQUALS_} "'${expect}'" "'${result}'"
}

. /usr/local/bin/shunit2
