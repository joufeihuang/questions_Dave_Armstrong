use "0705_Result.dta", clear
gen aid_trans = asinh(aid_gdp)

logit q179_china c.aid_trans##i.ethnic_chinese
margins, at(aid_trans = (0 12.8) ethnic_chinese=(0 1)) post
mlincom (4-3)-(2-1)


quietly logit q179_china c.aid_trans##i.ethnic_chinese
quietly margins, at(aid_trans = (0 12.8) ethnic_chinese=(0 1)) post
matrix b_full = e(b)
matrix v_full = e(V)

quietly logit q179_china aid_trans if ethnic_chinese == 0
quietly margins, at(aid_trans = (0 12.8)) post
matrix b0 = e(b)
matrix v0 = e(V)

quietly logit q179_china aid_trans if ethnic_chinese == 1
quietly margins, at(aid_trans = (0 12.8)) post
matrix b1 = e(b)
matrix v1 = e(V)

matrix z = J(2,2,0)


mata
v_full = st_matrix("v_full")
b_full = st_matrix("b_full")'

v_sub = st_matrix("v0"), st_matrix("z")\st_matrix("z"), st_matrix("v1")
b_sub = st_matrix("b0")'\st_matrix("b1")'

A = (1\-1\-1\1)


DD_full = A'*b_full
se_DD_full = sqrt(A'*v_full*A)
z_DD_full = DD_full/se_DD_full

DD_sub = A'*b_sub
se_DD_sub = sqrt(A'*v_sub*A)
z_DD_sub = DD_sub/se_DD_sub


DD_full
z_DD_full
DD_sub
z_DD_sub

end 

