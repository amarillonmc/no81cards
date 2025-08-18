--全域连接 菲米莉丝
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE+RACE_MACHINE),8,8)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	--world link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if #g==8 and g:GetClassCount(Card.GetRace)==8 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter(c)
	return c:IsRace(RACE_MACHINE+RACE_CYBERSE) and c:IsAbleToRemove(REASON_RULE)
end
function s.cpfilter(c)
	return c:IsRace(RACE_MACHINE+RACE_CYBERSE) and c:IsFaceup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(tp,g1)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,c)
	Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	local cg=Duel.GetMatchingGroup(s.cpfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local cc=cg:GetFirst()
	while cc do
		local code=cc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		cc=cg:GetNext()
	end
end