--人理之基 难近母
function c22023800.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020310,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),1,true,true)
	--Release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023800,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22023800)
	e1:SetCost(c22023800.relcost)
	e1:SetTarget(c22023800.target)
	e1:SetOperation(c22023800.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023800,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,22023800)
	e2:SetCost(c22023800.thcost)
	e2:SetTarget(c22023800.thtg)
	e2:SetOperation(c22023800.thop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023800,2))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,22023800)
	e3:SetCost(c22023800.hdcost)
	e3:SetTarget(c22023800.destg)
	e3:SetOperation(c22023800.desop)
	c:RegisterEffect(e3)
	--recycle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023800,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22023801)
	e4:SetCondition(c22023800.tgcon)
	e4:SetTarget(c22023800.tgtg)
	e4:SetOperation(c22023800.tgop)
	c:RegisterEffect(e4)
	--Release
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023800,5))
	e5:SetCategory(CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,22023800)
	e5:SetCondition(c22023800.erecon)
	e5:SetCost(c22023800.relcost1)
	e5:SetTarget(c22023800.target)
	e5:SetOperation(c22023800.operation)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22023800,6))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1,22023800)
	e6:SetCondition(c22023800.erecon)
	e6:SetCost(c22023800.thcost1)
	e6:SetTarget(c22023800.thtg)
	e6:SetOperation(c22023800.thop)
	c:RegisterEffect(e6)
	--handes
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22023800,7))
	e7:SetCategory(CATEGORY_HANDES)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1,22023800)
	e7:SetCondition(c22023800.erecon)
	e7:SetCost(c22023800.hdcost1)
	e7:SetTarget(c22023800.destg)
	e7:SetOperation(c22023800.desop)
	c:RegisterEffect(e7)
end
function c22023800.costfilter(c,e,tp,att,mc)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c22023800.relcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023800.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22023800.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22023800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c22023800.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Release(g,REASON_EFFECT)
	end
end
function c22023800.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22023800.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22023800.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023800.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22023800.thfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c22023800.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22023800.thfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c22023800.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023800.costfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22023800.costfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22023800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,2)
end
function c22023800.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,2)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c22023800.cfilter2(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_SZONE)) or c:IsPreviousLocation(LOCATION_MZONE)
end
function c22023800.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22023800.cfilter2,1,nil) and not eg:IsContains(e:GetHandler())
end
function c22023800.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023800.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c22023800.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023800.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023800,4))
	local g=Duel.SelectTarget(tp,c22023800.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c22023800.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c22023800.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023800.relcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023800.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22023800.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023800.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023800.hdcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023800.costfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22023800.costfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end