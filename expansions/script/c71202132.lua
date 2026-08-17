--静默之戟的"福耳库斯"
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.placecon)
	e1:SetOperation(s.placeop)
	c:RegisterEffect(e1)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.opcon)
	e2:SetTarget(s.optg)
	e2:SetOperation(s.opop)
	c:RegisterEffect(e2)
end
function s.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)
end
--①
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsLocation(LOCATION_MZONE)
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
--②
function s.opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function s.handfilter(c,e,tp)
	return c:IsSetCard(0x88f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.deckfilter(c)
	return c:IsSetCard(0x88f) and c:IsAbleToHand()
end
function s.atkfilter(c)
	return c:IsSetCard(0x88f) and c:IsFaceup()
end
function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.handfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0),1},
		{b2,aux.Stringid(id,1),2},
		{b3,aux.Stringid(id,2),3})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function s.opop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--special summon from hand
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.handfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		--search or send to grave from deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	elseif op==3 then
		--atk boost
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x88f) end,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
