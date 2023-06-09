#!/bin/sh
set -e

INPUT_TARGET_BRANCH=${INPUT_TARGET_BRANCH:-master}
INPUT_UPSTREAM_BRANCH=${INPUT_UPSTREAM_BRANCH:-master}
TARGET_REPOSITORY=${INPUT_TARGET_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Synchronizing repository ${TARGET_REPOSITORY}:${INPUT_TARGET_BRANCH} with ${INPUT_UPSTREAM_REPOSITORY}:${INPUT_UPSTREAM_BRANCH}";

[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    # shellcheck disable=SC2016
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".' 1>&2;
    exit 1;
};

[ -z "${INPUT_UPSTREAM_REPOSITORY}" ] && {
    echo 'Missing input "upstream_repository' 1>&2;
    echo '  e.g. "upstream_repository: EpicGames/UnrealEngine".' 1>&2;
    exit 1;
};

upstream_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
upstream_dir=${INPUT_UPSTREAM_REPOSITORY##*/}
target_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${TARGET_REPOSITORY}.git"

git clone "${upstream_repo}" -b "${INPUT_UPSTREAM_BRANCH}" --single-branch
cd "${upstream_dir}"
# shellcheck disable=SC2086
git push "${target_repo}" "${INPUT_UPSTREAM_BRANCH}:${INPUT_TARGET_BRANCH}"
rm -rf "../${upstream_dir}"
