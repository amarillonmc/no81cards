--圣沌大忍者 空即是色
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1=fuef.QF(c,c,1113,"ATK,CH,DAM+CAL,M,",cm.con1,",",cm.op1)
	local e2=fuef.F(c,c,"",m,"PTG,M,1+0")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(20000175)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"M","IsTyp+IsSet+IsPos-IsImmuneToEffect",{"M,5fd1,FU",e})
	if #g==0 then return end
	local e1=fuef.S(e,g,"",EFFECT_UPDATE_ATTACK,",",200,",,",RESET_EVENT+RESETS_STANDARD)
end