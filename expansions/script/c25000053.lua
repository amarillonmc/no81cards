--黯堕龙 凄厉空我
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000053)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),1,1,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsFusionType,TYPE_RITUAL))
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	local e1=rsef.FV_LIMIT(c,"dis",nil,nil,{0,LOCATION_MZONE },nil,nil,"cd")
	local e2=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"rm","cd,cn",LOCATION_MZONE,cm.rmcon,nil,cm.rmtg,cm.rmop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(cm.splimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.rmcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil,1-tp,POS_FACEDOWN,REASON_RULE)
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp)
		and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil,1-tp,POS_FACEDOWN,REASON_RULE)
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end