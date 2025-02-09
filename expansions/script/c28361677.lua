--乞巧的一等星 进步的祈愿
function c28361677.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28361677+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28361677.cost)
	e1:SetTarget(c28361677.target)
	e1:SetOperation(c28361677.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c28361677.thcon)
	e2:SetTarget(c28361677.thtg)
	e2:SetOperation(c28361677.thop)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28361677.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28361677.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28361677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28361677.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28361677.chkfilter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetMatchingGroupCount(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return #g>0 and ct>0 end
	if ct>#g then ct=#g end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SetTargetCard(cg)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28361677.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount()
	local g=Duel.GetMatchingGroup(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(c28361677.adcon)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetOperation(c28361677.adop2)
	e1:SetLabel(ct)
	e1:SetLabelObject(e:GetHandler())
	Duel.RegisterEffect(e1,tp)
	table.insert(c28361677.et,{e1})
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(c28361677.actop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c28361677.adop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28361677.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(ct)
		e1:SetCondition(c28361677.efcon)
		e1:SetOwnerPlayer(tp)
		xc:RegisterEffect(e1)
		table.insert(c28361677.get(e),xc)
	end
end
function c28361677.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRace(RACE_FAIRY) and ep==tp then
		Duel.SetChainLimit(c28361677.chainlm)
	end
end
function c28361677.chainlm(e,rp,tp)
	return tp==rp
end
function c28361677.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return eg:IsContains(e:GetHandler()) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284)
end
function c28361677.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c28361677.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=c:IsRelateToEffect(e)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28361677,0)},
		{b2,aux.Stringid(28361677,1)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c28361677.adcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOperation(c28361677.adop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
		table.insert(c28361677.et,{e1})
	else
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c28361677.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28361677.adf,tp,LOCATION_MZONE,0,1,nil,e)
end
function c28361677.adop(e,tp,eg,ep,ev,re,r,rp)
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28361677.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(1)
		e1:SetCondition(c28361677.efcon)
		e1:SetOwnerPlayer(tp)
		xc:RegisterEffect(e1)
		table.insert(c28361677.get(e),xc)
	end
end
function c28361677.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==e:GetOwnerPlayer()
end
c28361677.et = { }
function c28361677.get(v)
	for _,i in ipairs(c28361677.et) do
		if i[1]==v then return i end
	end
end
function c28361677.ck(e,c)
	local t = c28361677.get(e)
	for _,v in ipairs(t) do
		if v == c then return false end
	end
	return true
end
function c28361677.adf(c,e)
	return c:IsSetCard(0x284) and (c:GetLevel()>0 or c:GetRank()>0) and c28361677.ck(e,c)
end
