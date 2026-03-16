--黑兽之群 「成王」
local m=43990121
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,43990121+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c43990121.tdcon)
	e1:SetTarget(c43990121.tdtg)
	e1:SetOperation(c43990121.tdop)
	c:RegisterEffect(e1)
	--Act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990121,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c43990121.handcon)
	c:RegisterEffect(e2)
	--back to mzone
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(c43990121.tacon)
	e3:SetTarget(c43990121.tatg)
	e3:SetOperation(c43990121.taop)
	c:RegisterEffect(e3)
end
function c43990121.hffilter(c)
	return c:IsFaceup() and c:IsCode(43990120)
end
function c43990121.handcon(e)
	return Duel.IsExistingMatchingCard(c43990121.hffilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c43990121.tdcfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x6510) or c:IsCode(43990120))
end
function c43990121.tdcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c43990121.tdcfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c43990121.brfilter(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:IsSetCard(0x6510)
end
function c43990121.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c43990121.brfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,ct+1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,ct+1,0,0)
end
function c43990121.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c43990121.brfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,ct+1,ct+1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c43990121.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and c:IsFaceup() and c:IsSetCard(0x6510)
end
function c43990121.tacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c43990121.cfilter,1,nil)
end
function c43990121.tatg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990121.tdcfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c43990121.taop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c43990121.tdcfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end