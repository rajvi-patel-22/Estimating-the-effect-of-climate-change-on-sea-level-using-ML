function newdata = crop(time,data,first,last)

newdata = data(time>=first & time<last);

end