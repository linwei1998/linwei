function result = cep(mat,number)

    result=nan;
    if isempty(mat)
        return
    end
    if(number>1 ||number<0)
        return
    end
    result = mat(floor(number*length(mat)));
end