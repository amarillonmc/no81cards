--天夜 苍炎霸刀
function c60150620.initial_effect(c)
	c:SetUniqueOnField(1,0,60150620)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150620.ffilter,aux.FilterBoolFunction(c60150620.ffilter2),false)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150620.splimit)
	c:RegisterEffect(e2)
	
	--Immunity
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c60150620.efilter2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c60150620.discon)
	e4:SetTarget(c60150620.distg)
	e4:SetOperation(c60150620.disop)
	c:RegisterEffect(e4)
	--negate2
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetCountLimit(1)
	e6:SetCondition(c60150620.discon2)
	e6:SetTarget(c60150620.distg2)
	e6:SetOperation(c60150620.disop2)
	c:RegisterEffect(e6)
end
function c60150620.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150620.ffilter2(c)
	return c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60150620.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150620.efilter2(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c60150620.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg then return false end
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and tg:IsContains(e:GetHandler())
end
function c60150620.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if (re:GetHandler():IsAbleToDeck() or re:GetHandler():IsAbleToExtra()) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c60150620.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function c60150620.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60150620.discon2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg then return false end
	return (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or re:IsActiveType(TYPE_PENDULUM))
	and Duel.IsChainNegatable(ev) and tg:IsContains(e:GetHandler())
end
function c60150620.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c60150620.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		re:GetHandler():CancelToGrave()
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
	end
end