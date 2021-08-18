--迷石宫的秘境
function c60000028.initial_effect(c)
	c:EnableReviveLimit()   
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--SpecialSummon cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_ONFIELD)
	e4:SetCost(c60000028.ctcost)
	e4:SetOperation(c60000028.ctop)
	c:RegisterEffect(e4)
end
function c60000028.ctcost(e,c,tp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)==0 then 
	return false
	else
	return Duel.GetExtraTopGroup(tp,1):GetFirst():IsAbleToRemoveAsCost()
	end
end
function c60000028.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetExtraTopGroup(tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(60000028,3))
end
