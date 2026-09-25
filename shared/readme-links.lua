-- On the rendered site, README.md links go to the course's index.html instead
-- (Quarto doesn't render README.md files). On GitHub the links stay as written.
function Link(el)
  el.target = el.target:gsub("README%.md$", "index.html"):gsub("README%.md#", "index.html#")
  return el
end
