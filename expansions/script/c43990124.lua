--黑兽之军 「夜魅之兽」
local m=43990124
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c43990124.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,43990124)
	e1:SetTarget(c43990124.sbmtg)
	e1:SetOperation(c43990124.sbmop)
	c:RegisterEffect(e1)
	--back to mzone
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,43999124)
	e2:SetCondition(c43990124.bmcon)
	e2:SetTarget(c43990124.bmtg)
	e2:SetOperation(c43990124.bmop)
	c:RegisterEffect(e2)
	if not c43990124.global_check then
		c43990124.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c43990124.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
	
end
function c43990124.checkfliter(c)
	return c:IsSetCard(0x6510) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c43990124.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c43990124.checkfliter,1,nil,rp) then
		Duel.RegisterFlagEffect(rp,43990124,RESET_PHASE+PHASE_END,0,1)
	end
end
function c43990124.handcon(e)
	return Duel.GetFlagEffect(tp,43990124)>0
end


function c43990124.tempfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c43990124.tffilter(c,e,tp)
	return c:IsFaceup() and c:GetPreviousControler()==c:GetControler() and c43990119.tempfilter(c) and c:IsSetCard(0x6510) 
end
function c43990124.sbmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c43990124.tffilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c43990124.tffilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c43990124.tffilter,tp,LOCATION_REMOVED,0,1,ct,nil,e,tp)
end
function c43990124.sbmop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 or ft<sg:GetCount() then return end
		local tc=sg:GetFirst()
		while tc do
			local rc=tc
			if tc:GetReasonEffect() then rc=tc:GetReasonEffect():GetOwner() end
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(43990124)
			e1:SetLabelObject(tc)
			e1:SetOperation(c43990124.retop3)
			Duel.RegisterEffect(e1,0)
			Duel.RaiseEvent(tc,43990124,e,0,0,0,0)
			e1:Reset()
			tc=sg:GetNext()
		end
end
function c43990124.retop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function c43990124.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and c:IsFaceup() and c:IsSetCard(0x6510)
end
function c43990124.bmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c43990124.cfilter,1,nil)
end
function c43990124.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and c:IsFaceup() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_DECK+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c43990124.taop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if g:GetCount()>0 then
			local sg=g:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

