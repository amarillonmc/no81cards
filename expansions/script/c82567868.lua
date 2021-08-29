--方舟骑士·司令塔 凯尔希
function c82567868.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82567869),LOCATION_MZONE)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c82567868.tgcon)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--M3 Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567868,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c82567868.sptg)
	e2:SetCost(c82567868.spcost)
	e2:SetOperation(c82567868.spop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567868,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567868)
	e3:SetTarget(c82567868.target)
	e3:SetOperation(c82567868.operation)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82567868.negcon)
	e4:SetOperation(c82567868.negop)
	c:RegisterEffect(e4)
end
function c82567868.RUMfilter(c)
	return c:IsSetCard(0x95)
end
function c82567868.AKfilter(c)
	return c:IsSetCard(0x825)
end
function c82567868.M3filter(c)
	return c:IsCode(82567869) and c:IsFaceup()
end
function c82567868.KTfilter(c)
	return c:IsCode(82567868) and c:IsFaceup()
end
function c82567868.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local xm=e:GetHandler():GetOverlayGroup()
	return xm:IsExists(c82567868.AKfilter,1,nil) or Duel.IsExistingMatchingCard(c82567868.RUMfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function c82567868.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and not Duel.IsExistingMatchingCard(c82567868.M3filter,tp,LOCATION_MZONE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567868.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82567869,0,0x4011,3000,3000,8,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82567868.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82567869,0,0x4011,3000,3000,8,RACE_FIEND,ATTRIBUTE_DARK) or not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,82567869)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local g=Duel.GetOperatedGroup()
	local m3=g:GetFirst()
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c82567868.sdcon)
	m3:RegisterEffect(e4)
end
end
function c82567868.sdcon(e)
	return not Duel.IsExistingMatchingCard(c82567868.KTfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82567868.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanOverlay() and c:IsFaceup()
end
function c82567868.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  and c82567868.filter(chkc)  end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c82567868.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c82567868.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c82567868.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c82567868.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c82567868.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local xm=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,xm,xm,REASON_COST)
end
function c82567868.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c82567868.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c82567868.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567868.M3filter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and Duel.IsChainDisablable(ev)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c82567868.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(82567868,2)) then
		Duel.Hint(HINT_CARD,0,82567868)
		if Duel.NegateEffect(ev) and Duel.Destroy(re:GetHandler(),REASON_EFFECT) and 
			e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST) then
			Duel.BreakEffect()
		end
	end
end