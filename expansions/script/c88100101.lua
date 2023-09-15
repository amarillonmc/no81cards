--幻想蓝莓
function c88100101.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c88100101.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88100101.splimit)
	c:RegisterEffect(e1)
end
function c88100101.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c88100101.ffilter(c,fc,sub,mg,sg)
	return c:IsLevelAbove(1) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end