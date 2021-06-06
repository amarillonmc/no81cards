--稳重的龙之子 柯拉尔
local m=33711506
local cm=_G["c"..m]
function cm.initial_effect(c)
   aux.EnableDualAttribute(c)
	--Special Summon
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1) 
end
function cm.thfilter(c,tp)
	return c:IsControler(tp) and c:IsAbleToHand()
end
function cm.filter(c)
	local ct=c:GetColumnGroup():FilterCount(cm.thfilter,nil,1-tp)
	return ct>0 and c:IsAbleToHand()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
			if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
				local thg=c:GetColumnGroup():Filter(cm.thfilter,nil,1-tp)
				Duel.SendtoHand(thg,nil,REASON_EFFECT)
			end
	end
end