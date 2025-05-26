--裂界狂犬-迪蒙魔
function c11605017.initial_effect(c)
	c:SetSPSummonOnce(11605017)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa224),c11605017.mfilter,1,true)
	aux.AddContactFusionProcedure(c,c11605017.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,aux.tdcfop(c))
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11605017,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c11605017.cpcost)
	--e1:SetTarget(c11605017.cptg)
	e1:SetOperation(c11605017.cpop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11605017,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+11605017)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,11605017)
	e2:SetCondition(c11605017.eqcon)
	e2:SetTarget(c11605017.eqtg)
	e2:SetOperation(c11605017.eqop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,11605017,EVENT_SPSUMMON_SUCCESS)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2000)
	e3:SetCondition(c11605017.atkcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c11605017.eftg)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
end
c11605017.material_setcode=0xa224
function c11605017.mfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()
end
function c11605017.cfilter(c)
	return (c:IsFusionSetCard(0xa224) and c:IsType(TYPE_MONSTER) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) or c:IsLocation(LOCATION_REMOVED) and c:IsType(TYPE_MONSTER) and c:IsFaceup()) and c:IsAbleToDeckOrExtraAsCost()
end
function c11605017.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xa224) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()) then return false end
	local te=c.todeck_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c11605017.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11605017.cpfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c11605017.cpfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.todeck_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c11605017.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.todeck_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c11605017.eqfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xa224) and c:IsFaceup()
end
function c11605017.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11605017.eqfilter,1,nil,tp)
end
function c11605017.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c11605017.eqfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
end
function c11605017.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c11605017.eqlimit)
		c:RegisterEffect(e1)
	end
end
function c11605017.eqlimit(e,c)
	return c:IsSetCard(0xa224)
end
function c11605017.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsSetCard(0xa224)
end
function c11605017.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa224) and c:GetEquipGroup():IsContains(e:GetHandler())
end
