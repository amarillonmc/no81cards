--幻 叠 梦
local m=53799043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.filter2,c:GetControler(),0,LOCATION_GRAVE,1,c,c:GetCode())
end
function cm.filter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsCode(code)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.filter2(chkc,e,e:GetLabel()) end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(c:GetControler(),cm.filter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	local code=rg:GetFirst():GetCode()
	e:SetLabel(code)
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,c:GetPreviousControler(),HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(c:GetPreviousControler(),cm.filter2,c:GetPreviousControler(),0,LOCATION_GRAVE,1,1,nil,code)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
