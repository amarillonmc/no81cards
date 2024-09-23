--伊尔米涅特音乐会
function c28322511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28322511+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28322511.cost)
	e1:SetTarget(c28322511.target)
	e1:SetOperation(c28322511.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c28322511.thcon)
	e2:SetTarget(c28322511.thtg)
	e2:SetOperation(c28322511.thop)
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
function c28322511.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28322511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322511.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28322511.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28322511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c28322511.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(0x284)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28322511,2))
	end
end
function c28322511.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return eg:IsContains(e:GetHandler()) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284)
end
function c28322511.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c28322511.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=c:IsRelateToEffect(e)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28322511,0)},
		{b2,aux.Stringid(28322511,1)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c28322511.adcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOperation(c28322511.adop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
		table.insert(c28322511.et,{e1})
	else
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c28322511.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28322511.adf,tp,LOCATION_MZONE,0,1,nil,e)
end
function c28322511.adop(e,tp,eg,ep,ev,re,r,rp)
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28322511.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(1)
		e1:SetCondition(c28322511.efcon)
		e1:SetOwnerPlayer(tp)
		xc:RegisterEffect(e1)
		table.insert(c28322511.get(e),xc)
	end
end
function c28322511.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==e:GetOwnerPlayer()
end
c28322511.et = { }
function c28322511.get(v)
	for _,i in ipairs(c28322511.et) do
		if i[1]==v then return i end
	end
end
function c28322511.ck(e,c)
	local t = c28322511.get(e)
	for _,v in ipairs(t) do
		if v == c then return false end
	end
	return true
end
function c28322511.adf(c,e)
	return c:IsSetCard(0x284) and (c:GetLevel()>0 or c:GetRank()>0) and c28322511.ck(e,c)
end
