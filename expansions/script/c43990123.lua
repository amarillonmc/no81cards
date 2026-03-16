--黑兽之乱 「忏王之罚」
local m=43990123
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c43990123.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,43990123+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c43990123.rmtg)
	e1:SetOperation(c43990123.rmop)
	c:RegisterEffect(e1)
	--back to mzone
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c43990123.bmcon)
	e2:SetTarget(c43990123.bmtg)
	e2:SetOperation(c43990123.bmop)
	c:RegisterEffect(e2)
	if not c43990123.global_check then
		c43990123.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c43990123.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
end
function c43990123.checkfliter(c)
	return c:IsCode(43990116) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c43990123.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c43990123.checkfliter,1,nil,rp) then
		Duel.RegisterFlagEffect(rp,43990123,RESET_PHASE+PHASE_END,0,1)
	end
end
function c43990123.handcon(e)
	return Duel.GetFlagEffect(tp,43990123)>0
end

function c43990123.brfilter1(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:IsSetCard(0x6510)
end
function c43990123.brfilter2(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:IsCode(c43990120)
end
function c43990123.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(c43990123.brfilter1,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c43990123.brfilter2,tp,LOCATION_MZONE,0,nil)
	local ct=ct1+ct2*2
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ct,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,ct,1-tp,LOCATION_ONFIELD)
end
function c43990123.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c43990123.brfilter1,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c43990123.brfilter2,tp,LOCATION_MZONE,0,nil)
	local ct=ct1+ct2*2
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	end
end
function c43990123.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and c:IsFaceup() and c:IsSetCard(0x6510)
end
function c43990123.bmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c43990123.cfilter,1,nil)
end
function c43990123.thfilter(c)
	return c:IsSetCard(0x6510) and c:IsAbleToHand()
end
function c43990123.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c43990123.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_DECK+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990123.taop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c43990123.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end