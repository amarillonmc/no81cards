local m=4879034
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate2)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.rlcon2)
	c:RegisterEffect(e1)
end
function cm.rlcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)~=0
end
function cm.checkfilter(c,tp)
	return c:IsCode(m) and c:IsControler(tp)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if  re and re:GetHandler():IsSetCard(0xae55) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xae55)
end
function cm.filter(c)
	return c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.cfilter(c)
	return  c:IsAbleToExtra() and c:IsSetCard(0xae56)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
			end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetTarget(cm.sumlimit)
		e3:SetLabel(tc:GetCode())
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e4,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e5,tp)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_ACTIVATE)
		e6:SetValue(cm.aclimit)
		Duel.RegisterEffect(e6,tp)
	end
end
function cm.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end