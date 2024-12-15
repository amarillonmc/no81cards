--狂风精灵 飓风
function c51928007.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51928007,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,51928007)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c51928007.target)
	e1:SetOperation(c51928007.activate)
	c:RegisterEffect(e1)
	--position
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(filter2)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c51928007.immval)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(51928007,ACTIVITY_SPSUMMON,c51928007.counterfilter)
end
function c51928007.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end

function c51928007.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end

function c51928007.filter(c,e,tp)
	return c:IsSetCard(0x9256) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51928007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51928007,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928007.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c51928007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51928007.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelBelow(3) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(-3)
		c:RegisterEffect(e1)
		end
		
end
--------
function c51928007.immval(e,re)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and re:GetActivateLocation()==LOCATION_MZONE
		and (rc:IsRelateToEffect(re) and rc:IsDefensePos() or not rc:IsRelateToEffect(re) and rc:IsPreviousPosition(POS_DEFENSE))
end
function c51928007.filter2(c,e,tp)
	return c:IsSetCard(0x9256) and c:IsType(TYPE_MONSTER)
end