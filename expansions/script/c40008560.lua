--刻兽使·达干
function c40008560.initial_effect(c)
	c:SetUniqueOnField(1,0,40008560)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(40008560,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e0)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008560,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c40008560.seqtg1)
	e2:SetOperation(c40008560.seqop)
	c:RegisterEffect(e2)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008560,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c40008560.seqtg)
	e2:SetOperation(c40008560.seqop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008560,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c40008560.tdtg)
	e3:SetOperation(c40008560.tdop)
	c:RegisterEffect(e3)	
end
function c40008560.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17)
end
function c40008560.seqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40008560.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008560.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008560,1))
	Duel.SelectTarget(tp,c40008560.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c40008560.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40008560.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008560.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008560,1))
	Duel.SelectTarget(tp,c40008560.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40008560.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c40008560.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17) and c:IsAbleToDeck() and not c:IsCode(40008560)
end
function c40008560.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c40008560.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c40008560.thfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40008560.thfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c40008560.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
