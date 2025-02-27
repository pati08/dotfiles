return {
    s("beg", fmt([[
        \begin{<>}
            <>
        \end{<>}
    ]], {i(1), i(0), rep(1)}, {delimiters='<>'})),
    s("enum", fmt([[
        \begin{enumerate}
            <>
        \end{enumerate}
    ]], {i(0)}, {delimiters='<>'})),
    s("ulist", fmt([[
        \begin{itemize}
            <>
        \end{itemize}
    ]], {i(0)}, {delimiters='<>'})),
    s("sec", {t("\\section{"), i(0), t({ "}", "" })}),
    s("subsec", {t("\\subsection{"), i(0), t({ "}", "" })}),
    s("blank", t("\\rule{1cm}{0.01cm}")),
    s("it", { t("\\textit{"), i(1), t("}"), i(0) }),
    s("bf", { t("\\textbf{"), i(1), t("}"), i(0) }),
    s("ul", { t("\\underline{"), i(1), t("}"), i(0) }),
}
