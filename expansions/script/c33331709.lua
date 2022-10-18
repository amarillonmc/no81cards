--砾岩山谷路线图
local m=33331709
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cm.check(c)
	return c:IsAbleToHandAsCost() and c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_COST)
end
function cm.thcheck(c)
	return c:IsSetCard(0x565) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcheck,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thcheck,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.get(c,g)
	return g:IsExists(Card.IsRace,1,nil,c:GetRace())
end
function cm.ex(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=eg:Filter(cm.ex,nil,1-tp)
	local g=Duel.GetMatchingGroup(cm.get,1-tp,LOCATION_DECK,0,nil,fg)
	local a=g:CheckSubGroup(cm.gcheck,1,#fg,fg)
	local b=fg:IsExists(Card.IsAbleToHand,1,nil)
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.gcheck(g,fg)
	return g:GetClassCount(Card.GetRace) == #g and fg:GetClassCount(Card.GetRace)==#g
end
function cm.tgfil(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fg=eg:Filter(cm.ex,nil,1-tp)
	local g=Duel.GetMatchingGroup(cm.get,1-tp,LOCATION_DECK,0,nil,fg)
	local a=g:CheckSubGroup(cm.gcheck,1,#fg,fg)
	local b=fg:IsExists(Card.IsAbleToHand,1,nil)
	local op = 2
	if a and b then
		op = Duel.SelectOption(1-tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b then
		op = Duel.SelectOption(1-tp,aux.Stringid(m,3)) + 1
	elseif a then
		op = Duel.SelectOption(1-tp,aux.Stringid(m,2))
	else
		return
	end
	if op == 0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local rg=g:SelectSubGroup(1-tp,cm.gcheck,false,1,#fg,fg)
		if Duel.SendtoGrave(rg,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			for tc in aux.Next(og) do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_TRIGGER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	else 
		if Duel.SendtoHand(fg,nil,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
			local num = og:GetCount()
			Duel.BreakEffect()
			--local ft=Duel.GetMatchingGroupCount(1-tp,LOCATION_HAND)
			--if ft>num then
				ft = num
			--end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(1-tp,cm.tgfil,1-tp,LOCATION_HAND,0,ft,ft,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end