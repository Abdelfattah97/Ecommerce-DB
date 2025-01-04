select * from product
where concat(name,' ',description) ILike '%5g%';