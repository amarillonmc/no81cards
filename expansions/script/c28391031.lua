--L'Antica天体观测
function c28391031.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetTarget(c28391031.settg)
	e1:SetOperation(c28391031.setop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c28391031.indescon)
	e2:SetValue(c28391031.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c28391031.indescon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c28391031.drcon)
	e4:SetValue(c28391031.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(28391031,1))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(c28391031.tdtg)
	e6:SetOperation(c28391031.tdop)
	c:RegisterEffect(e6)
end
function c28391031.chkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285)
end
function c28391031.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c28391031.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and not c:IsForbidden() and c:CheckUniqueOnField(tp) end
	Duel.SetChainLimit(c28391031.limit(e:GetHandler()))
end
function c28391031.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c28391031.dsfilter(c)
	return c:IsSetCard(0x285) and c:IsFaceupEx()
end
function c28391031.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28391031.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not Duel.IsExistingMatchingCard(c28391031.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)) or (not c:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28391031.chkfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	local g1=Duel.GetMatchingGroup(c28391031.dsfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(c28391031.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) and #g1>0 and #g2>1 and Duel.SelectYesNo(tp,aux.Stringid(28391031,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g1:Select(tp,1,1,nil)
		if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c28391031.indescon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=3000
end
function c28391031.efilter(e,te)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c28391031.drcon(e)
	local p=e:GetHandlerPlayer()
	return Duel.GetLP(p)<=3000 and Duel.IsExistingMatchingCard(c28391031.dsfilter,p,LOCATION_MZONE,0,1,nil)
end
function c28391031.damval(e,re,val,r,rp,rc)
	return 0
end
function c28391031.tdfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c28391031.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28391031.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c28391031.atkfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c28391031.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28391031.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	if tg:GetCount()==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local ag=Duel.GetMatchingGroup(c28391031.atkfilter,tp,LOCATION_MZONE,0,nil,e)
	if ct>0 and #ag>0 then
		for tc in aux.Next(ag) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
