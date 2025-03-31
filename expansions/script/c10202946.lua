--风暴之天气模样
function c10202946.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10202946,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10202946)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c10202946.descon)
	e2:SetTarget(c10202946.destg)
	e2:SetOperation(c10202946.desop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10202946,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10202947)
	e3:SetCost(c10202946.remcost)
	e3:SetTarget(c10202946.remtg)
	e3:SetOperation(c10202946.remop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10202946,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,10202948)
	e4:SetCost(c10202946.spcost)
	e4:SetCondition(c10202946.setcon1)
	e4:SetTarget(c10202946.sptg)
	e4:SetOperation(c10202946.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,10202948)
	e5:SetCondition(c10202946.setcon2)
	c:RegisterEffect(e5)
end
function c10202946.cfilter(c)
	return c:IsFaceup() and (c:IsCode(22702055) or c:IsLocation(LOCATION_MZONE) and aux.IsCodeListed(c,22702055))
end
function c10202946.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c10202946.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10202946.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10202946.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then Duel.Destroy(tc,REASON_EFFECT) end
end
--2
function c10202946.costfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
end
function c10202946.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10202946.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10202946.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Remove(g,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local rc=g:GetFirst()
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c10202946.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10202946.thfilter(c)
	return c:IsAbleToHand() and (aux.IsCodeListed(c,22702055) or (c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER)) or c:IsSetCard(0x177))
end
function c10202946.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10202946.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c10202946.remop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10202946.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10202946.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--3
function c10202946.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10202946.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10202946.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10202946.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10202946.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10202946.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--这个效果在对方回合也能发动。
function c10202946.setcfilter(c)
	return c:IsFaceup() and c:IsCode(23931679)
end
function c10202946.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(c10202946.setcfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c10202946.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c10202946.setcfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
