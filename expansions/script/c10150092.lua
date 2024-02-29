--光元天使
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150092)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"des,sp",nil,LOCATION_HAND+LOCATION_GRAVE,nil,nil,rsop.target({rscf.spfilter2(),"sp"},{cm.desfilter,"des",LOCATION_HAND+LOCATION_MZONE }),cm.spop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},"se,th","de,dsp",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.desreptg)
	e3:SetValue(cm.desrepval)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
end
function cm.desfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsLevelAbove(5)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or rssf.SpecialSummon(c)<=0 or not Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) then return end
	Duel.BreakEffect()
	rsop.SelectDestroy(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,{})
end
function cm.thcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.thfilter(c)
	return c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end