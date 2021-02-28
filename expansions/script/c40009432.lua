--机械加工 鼠妇
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009432)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5f1d),2,2)
	local e1 = rsef.I(c,"sp",{1,m},"tk,sp",nil,LOCATION_MZONE,nil,nil,cm.tktg,cm.tkop)
	local e2 = rsef.QO(c,nil,"des",{1,m+100},"des","tg",LOCATION_MZONE,nil,nil,rstg.target({Card.IsFaceup,cm.gcheck},"des",LOCATION_ONFIELD,LOCATION_ONFIELD,2,2),cm.desop)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40009433,0,0x4011,500,500,2,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,40009433,0,0x4011,500,500,2,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,40009433)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function cm.gcheck(g,e,tp)
	return g:IsExists(Card.IsCode,1,nil,40009433) and g:GetClassCount(aux.GetColumn)==1
end
function cm.desop(e,tp)
	local dg = rsgf.GetTargetGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end