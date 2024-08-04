--红血姬-吸血鬼·莉莉丝
function c87498034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c87498034.lvtg)
	e1:SetValue(c87498034.lvval)
	c:RegisterEffect(e1) 
	--lpcost replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87498034,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_LPCOST_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87498034.lrcon)
	e1:SetOperation(c87498034.lrop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87498034,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,87498034) 
	e2:SetCondition(c87498034.discon)
	e2:SetCost(c87498034.discost)
	e2:SetTarget(c87498034.distg)
	e2:SetOperation(c87498034.disop)
	c:RegisterEffect(e2)
end
function c87498034.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c87498034.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 6
	else return lv end
end
function c87498034.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<ev then return false end
	if not re or not re:IsActivated() then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x8e) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c87498034.lrop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,87498034) 
end
function c87498034.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c87498034.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c87498034.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_NEGATE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:GetHandler():IsRelateToEffect(re)
		and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c87498034.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:GetHandler():IsRelateToEffect(re) and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.BreakEffect()
		Duel.GetControl(re:GetHandler(),tp)
	end
end





