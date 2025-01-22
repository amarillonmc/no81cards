--去未知处
--21.04.21
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,e:GetHandlerPlayer())>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)+Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,1-tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local max=0
	local maxzone1=0
	local maxzone2=0
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then
			Duel.Hint(HINT_ZONE,tp,1<<i)
			Duel.Hint(HINT_ZONE,1-tp,1<<(i+16))
			local td=Duel.TossDice(tp,1)
			if td==max then
				maxzone1=maxzone1|1<<i
			elseif td>max then
				max=td
				maxzone1=1<<i
			end
		end
	end
	for i=0,4 do
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then
			Duel.Hint(HINT_ZONE,tp,1<<(i+16))
			Duel.Hint(HINT_ZONE,1-tp,1<<i)
			local td=Duel.TossDice(tp,1)
			if td==max then
				maxzone2=maxzone2|1<<i
			elseif td>max then
				max=td
				maxzone1=0
				maxzone2=1<<i
			end
		end
	end
	if max==0 or (maxzone1==0 and maxzone2==0) then return end
	local s1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,maxzone1)
	local s2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,maxzone2)
	local op=0
	if s1 and s2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif s1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif s2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
		Duel.ShuffleDeck(tp)
		return
	end
	local p=tp
	if op==1 then
		p=1-tp
		maxzone1=maxzone2
	end
	if Duel.SpecialSummonStep(tc,0,tp,p,false,false,POS_FACEUP,maxzone1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end