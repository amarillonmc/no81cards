--多元闪刀机关-多任务战刀机
function c978210011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(978210011,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c978210011.tgtg)
	e2:SetOperation(c978210011.tgop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(978210011,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c978210011.settg)
	e3:SetOperation(c978210011.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c978210011.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(c978210011.regop2)
	c:RegisterEffect(e5)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e9)
end
function c978210011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.GetFlagEffect(tp,978211011)==0 and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c978210011.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c978210011.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,978211011,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c978210011.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c978210011.chainlm)
	end
end
function c978210011.chainlm(e,rp,tp)
	return tp==rp
end
function c978210011.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x2115) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(978210011)
		if flag then
			c:SetFlagEffectLabel(978210011,flag+1)
		else
			c:RegisterFlagEffect(978210011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function c978210011.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x2115) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(978210011)
		if flag and flag>0 then
			c:SetFlagEffectLabel(978210011,flag-1)
		end
	end
end
function c978210011.setfilter(c)
	return c:IsSetCard(0x2115) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c978210011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(978210011)
	if chk==0 then return ct and ct>0 and Duel.IsExistingMatchingCard(c978210011.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c978210011.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and aux.dncheck(g) and #g-fc<=ft
end
function c978210011.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c978210011.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetHandler():GetFlagEffectLabel(978210011) or 0
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #g==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,c978210011.gselect,false,1,math.min(ct,ft+1),ft)
	if Duel.SSet(tp,tg)==0 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end