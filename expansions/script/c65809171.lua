--策略 成本压缩
local s,id,o=GetID()
function s.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end
function s.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsSetCard(0xca30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
--
function s.e2filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and not c:IsCode(id) and c:IsSetCard(0xca30,0xaa30) and c:IsAbleToGrave()
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.e2filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.e2filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.e2filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local g=Duel.GetDecktopGroup(1-tp,1)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
function s.e3filter(c)
	return c:IsFaceup() and not c:IsCode(id) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.e3filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.e3filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.e3filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end