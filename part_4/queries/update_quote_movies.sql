-- Surround all movie titles with quotes
update Item
set title = concat('"', title, '"')
where mediaType = 'movie' and
      title not like '"%"';
