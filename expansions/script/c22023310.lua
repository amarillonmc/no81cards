--人理之基 大和武尊
function c22023310.initial_effect(c)
	aux.AddCodeList(c,22023320)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023310,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22023310.tdcon)
	e1:SetTarget(c22023310.target)
	e1:SetOperation(c22023310.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023310,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023310)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c22023310.rmcon1)
	e2:SetCost(c22023310.rmcost)
	e2:SetTarget(c22023310.rmtg)
	e2:SetOperation(c22023310.rmop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023310,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22023310)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c22023310.eqcost)
	e3:SetTarget(c22023310.eqtg)
	e3:SetOperation(c22023310.eqop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023310,9))
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22023310)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c22023310.rmcon2)
	e4:SetCost(c22023310.rmcost1)
	e4:SetTarget(c22023310.rmtg1)
	e4:SetOperation(c22023310.rmop1)
	c:RegisterEffect(e4)
	--remove ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023310,13))
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,22023310)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c22023310.rmcon3)
	e5:SetCost(c22023310.rmcost2)
	e5:SetTarget(c22023310.rmtg1)
	e5:SetOperation(c22023310.rmop1)
	c:RegisterEffect(e5)
end
function c22023310.cfilter(c,tp)
	return c:IsSetCard(0xff1)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c22023310.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22023310.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c22023310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return tc:FilterCount(Card.IsAbleToChangeControler,nil)==2 end
end
function c22023310.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then
		dr=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	end
	Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(tp,2))
end
function c22023310.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,8,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,8,8,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22023310,3))
end
function c22023310.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023310,4))
end
function c22023310.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,8,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SelectOption(tp,aux.Stringid(22023310,5))
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c22023310.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,10,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,10,10,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22023310,6))
end
function c22023310.filter(c,ec)
	return c:IsCode(22023320) and c:CheckEquipTarget(ec)
end
function c22023310.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22023310.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SelectOption(tp,aux.Stringid(22023310,7))
end
function c22023310.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c22023310.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22023310,8))
		Duel.Equip(tp,g:GetFirst(),c)
	end
end
function c22023310.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22023320)
end
function c22023310.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22023320)
end
function c22023310.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
	Duel.SelectOption(tp,aux.Stringid(22023310,10))
end
function c22023310.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023310,11))
end
function c22023310.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,8,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SelectOption(tp,aux.Stringid(22023310,12))
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c22023310.rmcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22023320) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023310.rmcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
	Duel.SelectOption(tp,aux.Stringid(22023310,10))
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end