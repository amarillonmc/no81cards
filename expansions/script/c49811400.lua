--リーサル・バグ
function c49811400.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c49811400.excondition)
	e0:SetDescription(aux.Stringid(49811400,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811400)
	e1:SetCost(c49811400.cost)
	e1:SetTarget(c49811400.target)
	e1:SetOperation(c49811400.activate)
	c:RegisterEffect(e1)
	--bfgeffect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811400,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c49811400.bfgcondition)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,49811401)
	e2:SetTarget(c49811400.bfgtg)
	e2:SetOperation(c49811400.bfgop)
	c:RegisterEffect(e2)
end
function c49811400.excondition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)>0
end
function c49811400.costfilter(c)
	return c:IsLevel(3) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost()
end
function c49811400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811400.costfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c49811400.costfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c49811400.thfilter(c)
	return c:IsCode(86804246,69042950) and c:IsAbleToHand()
end
function c49811400.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811400.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	--if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
	--	e:SetLabel(100)
	--	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	--end
end
function c49811400.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811400.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g then
		tg=g:Select(tp,false,1,1)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
			--if e:GetLabel()==100 then
			--	Duel.Damage(tp,1000,REASON_EFFECT)
			--end
		end
	end
end
function c49811400.bfgcondition(e,tp,eg,ep,ev,re,r,rp)
	return ev>=3000
end
function c49811400.posfilter(c)
	return c:IsCanChangePosition()
end
function c49811400.tgfilter(c,e)
	return Duel.IsPlayerCanSendtoGrave(e:GetHandlerPlayer(),c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c49811400.xfilter(c)
	return c:IsAbleToGrave()
end
function c49811400.bfgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c49811400.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c49811400.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e)
	local b3=Duel.GetOverlayGroup(tp,1,1):IsExists(c49811400.xfilter,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 or b3 end
end
function c49811400.bfgop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c49811400.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(49811400,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
	local b2=Duel.IsExistingMatchingCard(c49811400.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(49811400,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,c49811400.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
		if gg:GetCount()>0 then
			Duel.HintSelection(gg)
			Duel.SendtoGrave(gg,REASON_EFFECT)
		end
	end
	local b3=Duel.GetOverlayGroup(tp,1,1):IsExists(c49811400.xfilter,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(49811400,4)) then
		local og=Duel.GetOverlayGroup(tp,1,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=og:FilterSelect(tp,c49811400.xfilter,1,1,nil)
	    if Duel.SendtoGrave(sg,REASON_EFFECT) then
	    	Duel.Draw(tp,1,REASON_EFFECT)
	    end
	end
end