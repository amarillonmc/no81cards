--忍防之圣沌 八方
dofile("expansions/script/c20000175.lua")
local cm,m = fu_HC.T_initial()
--e1
function cm.e1(c)
	fuef.A(c):OP("op1")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1 = fuef.S(e,EFFECT_INDESTRUCTABLE_EFFECT,tp):PRO("SET"):TRAN("MS+0"):VAL(1):TG("optgf1"):RES("PH/ED|2")
	e1(EFFECT_CANNOT_BE_EFFECT_TARGET):PRO("SET+IG"):VAL("tgoval")
	if fu_HC.chk[tp+1]==0 or #g==0 then return end
	e1(EFFECT_CANNOT_BE_EFFECT_TARGET):TG("optgf2")(EFFECT_CANNOT_BE_EFFECT_TARGET):PRO("SET+IG"):VAL("tgoval")
end
function cm.optgf1(e,c)
	return fucf.Filter(c,"(IsTyp+IsPos)/IsPos","T,FU,FD") and c:IsLocation(LOCATION_ONFIELD)
end
function cm.optgf2(e,c)
	return fucf.Filter(c,"IsTyp+IsSet+IsPos","M,5fd1,FU") and c:IsLocation(LOCATION_ONFIELD)
end