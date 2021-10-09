--夏日乱斗·水着葛饰北斋
function c9981478.initial_effect(c)
		 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981478,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9981478+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c9981478.sptg)
	e2:SetOperation(c9981478.spop)
	c:RegisterEffect(e2)
   --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981478,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9981478.rmtg)
	e1:SetOperation(c9981478.rmop)
	c:RegisterEffect(e1)
end
function c9981478.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9981478,0xba5,0x11,1900,1200,4,RACE_WARRIOR,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981478.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9981478,0xba5,0x11,1900,1200,4,RACE_WARRIOR,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		--redirect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981478,0))
end
function c9981478.chkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsAbleToRemove()
end
function c9981478.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c9981478.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c9981478.rmfilter,tp,0,LOCATION_ONFIELD,1,nil)
			and not Duel.IsExistingMatchingCard(c9981478.chkfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(c9981478.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9981478.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981478.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end