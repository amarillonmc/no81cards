--远古造物 桑氏远洋鸟
require("expansions/script/c9910700")
function c9910309.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetCondition(c9910309.condition)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910309,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c9910309.rtcon)
	e2:SetTarget(c9910309.rttg)
	e2:SetOperation(c9910309.rtop)
	c:RegisterEffect(e2)
end
function c9910309.condition(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9910309.cfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c9910309.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910309.cfilter,1,nil)
end
function c9910309.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9910308)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9910309)==0
	if chk==0 then return b1 or b2 end
end
function c9910309.rtop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9910308)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,9910309)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9910309,1),aux.Stringid(9910309,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9910309,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(9910309,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,9910308,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,9910309,RESET_PHASE+PHASE_END,0,1)
	end
end
