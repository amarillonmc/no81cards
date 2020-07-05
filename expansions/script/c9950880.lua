--逢魔终结踢
function c9950880.initial_effect(c)
--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9950880.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950880+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9950880.target)
	e1:SetOperation(c9950880.activate)
	c:RegisterEffect(e1)
 --Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950880,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,100424122)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9950880.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950880.destg)
	e2:SetOperation(c9950880.desop)
	c:RegisterEffect(e2)
end
function c9950880.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3) 
end
function c9950880.handcon(e)
	return Duel.IsExistingMatchingCard(c9950880.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9950880.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToDeck()
end
function c9950880.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9950880.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950880.filter,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9950880.filter,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c9950880.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9950880.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3)
end
function c9950880.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950880.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950880.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9950880.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9950880.desfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9950880.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c9950880.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local atk=tc:GetBaseAttack()
			if atk>0 then
				Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
		end
	end
end

