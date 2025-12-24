--幻叙幻现幻想奇谭
local s,id,o=GetID()
function s.initial_effect(c)
	-- Activate card
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Select one option
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2,id)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	-- Change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.chcon)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x838) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.tdfilter(c)
	return c:IsSetCard(0x838) and c:IsAbleToDeck()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tgfilter(c)
	return c:IsSetCard(0x838) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		Duel.PayLPCost(tp,1000)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	elseif op==2 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	elseif op==3 then
		e:SetCategory(CATEGORY_TOGRAVE)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g1>0 and Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if #g2>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetValue(ATTRIBUTE_WATER)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and re:IsActiveType(TYPE_MONSTER)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.FromCards(re:GetHandler())
	Duel.ChangeChainOperation(ev,function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end)
end
