str = 'my_name_is_eric';
after_split = split(str, '_');
for i = 1:length(after_split)
    if strcmpi(after_split(i), {'eric'}) == 1
        after_split(i)
    end
end
