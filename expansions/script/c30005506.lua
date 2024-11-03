--混合体的暴走
local m=30005506
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	--e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--Effect 1
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e03:SetCode(EVENT_CHAINING)
	e03:SetRange(LOCATION_SZONE)
	e03:SetOperation(cm.chainop)
	c:RegisterEffect(e03)
	--Effect 2  
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,0))
	--e3:SetCategory(CATEGORY_DESTROY)
	--e3:SetType(EFFECT_TYPE_QUICK_O)
	--e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e3:SetCode(EVENT_FREE_CHAIN)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1)
	--e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e3:SetCondition(cm.descon)
	--e3:SetTarget(cm.destg)
	--e3:SetOperation(cm.desop)
	--c:RegisterEffect(e3)
	--Effect 3 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.rcon)
	e2:SetTarget(cm.rtg)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if (rc:IsSetCard(0x927) or re:IsActiveType(TYPE_FUSION)) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
--Effect 2
function cm.descon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--Effect 3 
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.filter(c,ec,e,tp)
	if not c:IsSetCard(0x927) or c:IsFacedown() then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(cm.ofilter,1,nil,g,e,tp)
end
function cm.ofilter(c,g,e,tp)
	return c:IsAbleToHand() and g:IsExists(Card.IsAbleToDeck,1,c)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,c,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local fg=(Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)+e:GetHandler()):Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=fg:FilterSelect(tp,cm.ofilter,1,1,nil,fg,e,tp)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 
		and sg:GetFirst():IsLocation(LOCATION_HAND) then 
		Duel.SendtoDeck(fg-sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end