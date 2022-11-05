--破坏之使徒
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove()
end
function cm.filter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local bool=tc:IsSummonLocation(LOCATION_EXTRA)
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		if bool then
			local code=tc:GetCode()
			local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil,code)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g)
			g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end