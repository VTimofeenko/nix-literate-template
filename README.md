# What

This repo provides a template to help with literate programming of Nix projects.

When the source blocks are interspersed with text (as is common), the nix indentation in orgmode may get a little confused which can cause garbage formatting changes. Two provided functions help integrate `nix fmt` changes back into orgmode.

# Features

- Write in org -- then tangle, format and detangle with one function
- Edit a tangled file directly -- propagate changes back
- Basic feature tags for semantic commits

# Usage

When working on a orgmode file, call custom functions `local-proj-tangle-format-detangle` to:

1. Tangle all src blocks
2. Call `nix fmt` to apply formatter from the flake
3. Detangle all sources back into orgmode file to fix formatting

Alternatively, when a `.nix` file was edited directly -- call `local-proj-detangle-all` in orgmode to detangle all changes back.

## Using as before-save-hook

It's possible to use similar functions as a pre-save hook (see caveats for, well, caveats). `.dir-locals.el` for this:

```elisp
((org-mode
   (eval add-hook 'before-save-hook (lambda ()(org-babel-tangle)) t t)
   ;; Run nix fmt before save
   (eval add-hook 'before-save-hook (lambda ()(shell-command "nix fmt")) t t)
   (eval add-hook 'before-save-hook
         (lambda ()
           (let ((previous-value org-src-window-setup))
             ;; temporarily break org-src-window-setup, otherwise detangle creates unneeded frames
             (setq org-src-window-setup 'nil)

             (mapcar #'org-babel-detangle (directory-files-recursively "." ".*\.nix"))
             ;; revert org-src-window-setup
             (setq org-src-window-setup previous-value))) t t)))
```

# Example

See [project.org](./project.org) for the sample org mode file.


# Alternatives

- [org-tanglesync.el](https://gitlab.com/mtekman/org-tanglesync.el)
- `org-babel-detangle` -- note, may cause extra frames with files to appear. This is worked around in `local-proj-detangle-all`.

# Caveats

- The current detangle behavior does not work well if multiple headlines (even on different level) have the same text -- stuff can get **overwritten** when detangling. Workaround: change #+NAME of code block or rename the headline. Alternatively, change logic of ~org-babel-tangle-comment-format-beg~ generation.
- It's possible to use the function from `.dir-locals.el` as a before-save hook but if the number of src blocks is >40(empricial number), it will noticeably slow down the save process
- When detangling -- the cursor loses its position and jumps to the beginning of SRC block.
