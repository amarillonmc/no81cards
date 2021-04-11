--马纳历亚公主·安
function c72411170.initial_effect(c)
	aux.AddCodeList(c,72411020,72411030)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c72411170.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x5729),1,99)
	c:EnableReviveLimit()
	--link success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411170,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72411170)
	e1:SetCondition(c72411170.con)
	e1:SetTarget(c72411170.target)
	e1:SetOperation(c72411170.operation)
	c:RegisterEffect(e1)
end
function c72411170.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_NORMAL)
end
function c72411170.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c72411170.filteratk(c)
	return c:IsCode(72411020) 
end
function c72411170.filterdef(c)
	return c:IsCode(72411030) 
end
function c72411170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b0=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b1=Duel.IsExistingMatchingCard(c72411170.filteratk,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c72411170.filterdef,tp,LOCATION_GRAVE,0,1,nil)
	local op=0
	if b0 and b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(72411170,1),aux.Stringid(72411170,2))
	elseif b0 and b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(72411170,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(72411170,2))+1 
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,nil,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,0)
	end
end
function c72411170.linklimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end
function c72411170.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER)
end
function c72411170.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local a1=Duel.GetMatchingGroupCount(c72411170.filteratk,tp,LOCATION_GRAVE,0,nil)
	local a2=Duel.GetMatchingGroupCount(c72411170.filterdef,tp,LOCATION_GRAVE,0,nil)
	if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g1=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,0,a1,nil)
			if g1~=0 then
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			end
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and a2>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,72411171,0,0x4011,1000,1000,1,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then
			local count=math.min(ft,a2)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
			if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(72411170,3))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
			end
			repeat
				local token=Duel.CreateToken(tp,72411171)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetValue(c72411170.linklimit)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e5)
				local e6=e5:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e6:SetValue(c72411170.synlimit)
				token:RegisterEffect(e6)
			count=count-1
			until count==0
		Duel.SpecialSummonComplete()
	end
end
end

