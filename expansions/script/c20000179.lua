--忍防之圣沌 八方
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.T_initial()
--e1
cm.e1 = fuef.A():OP("op1")
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1 = fuef.S(e,EFFECT_INDESTRUCTABLE_EFFECT,tp):PRO("SET"):TRAN("MS+0"):VAL(1):TG("op1tg1"):RES("PH/ED",2)
	if fu_HC.chk[tp+1]==0 then return end
	e1(EFFECT_CANNOT_BE_EFFECT_TARGET):PRO("SET+IG"):VAL("tgoval")
end
function cm.op1tg1(e,c)
	return fucf.Filter(c,"IsLoc+IsPos/(IsTyp+IsSet)","MS,FD,M,5fd1")
end