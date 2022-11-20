--暗元恶魔
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150093)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"des,sp",nil,LOCATION_HAND+LOCATION_GRAVE,nil,nil,rsop.target({rscf.spfilter2(),"sp"},{cm.desfilter,"des",LOCATION_HAND+LOCATION_MZONE }),cm.spop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},"sp","de,dsp",cm.spcon,nil,rsop.target(cm.spfilter,"sp",rsloc.hg,0,1,1,c),cm.spop2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
end
function cm.desfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsLevelAbove(5)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or rssf.SpecialSummon(c)<=0 or not Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) then return end
	Duel.BreakEffect()
	rsop.SelectDestroy(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,{})
end
function cm.spcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop2(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hg,0,1,1,aux.ExceptThisCard(e),{0,tp,tp,false,false,POS_FACEUP,nil,{"dis,dise"}})
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc4) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end