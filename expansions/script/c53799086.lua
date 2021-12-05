local m=53799086
local cm=_G["c"..m]
cm.name="沉默的Comfy"
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
		and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<=0
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.Draw(1-tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(tp,tc)
		if not tc:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
