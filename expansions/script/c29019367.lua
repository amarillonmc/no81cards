--方舟骑士团·出鞘
local m=29019367
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,29019367)
	e1:SetCondition(c29019367.wxcon)
	e1:SetTarget(c29019367.wxtg)
	e1:SetOperation(c29019367.wxop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29019367.actcon)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29019367)
	e3:SetCondition(c29019367.rcon)
	e3:SetOperation(c29019367.rop)
	c:RegisterEffect(e3)
	
end
function c29019367.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToRemoveAsCost() and ep==e:GetOwnerPlayer()
end
function c29019367.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29019367.hafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x87af) and c:IsType(TYPE_XYZ)
end
function c29019367.actcon(e)
	return Duel.IsExistingMatchingCard(c29019367.hafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c29019367.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x87af) and c:IsControler(tp)
end
function c29019367.wxcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
	return p==1-tp and g:IsExists(c29019367.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c29019367.wxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c29019367.wxop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29019367,1)) then
		Duel.Destroy(eg,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
	end
end

