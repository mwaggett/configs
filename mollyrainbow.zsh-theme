USER_COLOR=046
HOST_COLOR=035
DIRECTORY_COLOR=038
GIT_BRANCH_COLOR=069
PROMPT_COLOR=093


local return_code="%(?..%{$FG[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$FG[$USER_COLOR]%}%n%{$reset_color%}@%{$FG[$HOST_COLOR]%}%m\
%{$reset_color%}:%{$FG[$DIRECTORY_COLOR]%}%~\
$(git_prompt_info) \
%{$FG[$PROMPT_COLOR]%}%(!.#.$)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[$GIT_BRANCH_COLOR]%}("
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[green]%}👌 %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[red]%}😬 %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[$GIT_BRANCH_COLOR]%})%{$reset_color%}"

# Not sure what these do, just copied from an existing theme
PROMPT2='%{$FG[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

