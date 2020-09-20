--柱男的传说
function c9980511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980511+EFFECT_COUNT_CODE_OATH)
	e1:SetCountLimit(1,9980511)
	e1:SetLabel(0)
	e1:SetCost(c9980511.cost)
	e1:SetTarget(c9980511.target)
	e1:SetOperation(c9980511.operation)
	c:RegisterEffect(e1)
	 --change pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980511,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,99805110)
	e3:SetTarget(c9980511.postg)
	e3:SetOperation(c9980511.posop)
	c:RegisterEffect(e3)
end
function c9980511.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5bcc) or c:IsRace(RACE_ROCK))and c:IsAbleToRemoveAsCost()
end
function c9980511.thfilter(c,code1,code2)
	return c:IsSetCard(0x5bcc) and c:IsAbleToHand() and not c:IsCode(9980511,code1,code2)
end
function c9980511.costcheck(g,tp)
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9980511.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	return tg:CheckSubGroup(aux.dncheck,2,2)
end
function c9980511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9980511.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9980511.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(c9980511.costcheck,2,2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9980511.costcheck,false,2,2,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9980511.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9980511.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980511,0))
	end
end
function c9980511.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9980511.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9980511.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980511.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c9980511.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9980511.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end