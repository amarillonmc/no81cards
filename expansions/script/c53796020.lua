local m=53796020
local cm=_G["c"..m]
cm.name="帝王切开"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsFaceup() and rc:IsOnField() and re:IsHasCategory(CATEGORY_TOHAND+CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
