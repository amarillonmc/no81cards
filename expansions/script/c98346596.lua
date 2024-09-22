--神明的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf7),aux.NonTuner(Card.IsSetCard,0xaf7),1)
	c:EnableReviveLimit()
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(98346596,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c98346596.descon)
	e1:SetTarget(c98346596.destg)
	e1:SetOperation(c98346596.desop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346596,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,id)
	e2:SetCost(c98346596.hdcost)
	e2:SetTarget(c98346596.hdtg)
	e2:SetOperation(c98346596.regop)
	c:RegisterEffect(e2)
end
function c98346596.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&TYPE_SPELL~=0 or c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&TYPE_TRAP~=0) and c:IsSpecialSummonSetCard(0xaf7)) or e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98346596.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
			and (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) or Duel.IsPlayerCanDraw(tp,1))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98346596.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local b1=Duel.IsPlayerCanDraw(tp,1)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
		if not b1 and not b2 then return end
		local op=0
		if b1 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(98346596,1))
		elseif not b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(98346596,2))+1
		else op=Duel.SelectOption(tp,aux.Stringid(98346596,1),aux.Stringid(98346596,2)) end
		if op==0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif op==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function c98346596.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xaf7)
end
function c98346596.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98346596.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:Select(tp,1,1,nil)
	Duel.Remove(tg,POS_FACEDOWN,REASON_COST)
end
function c98346596.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c98346596.hdop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98346596.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function c98346596.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) then
		Duel.ConfirmCards(tp,g0)
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			sg=g:Select(1-tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end