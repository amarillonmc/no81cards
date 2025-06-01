--崩坏神格 纹章
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646000)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.con)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e5:SetCountLimit(3,75646150)
	e5:SetCost(s.thcost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x52c0)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		e:GetHandler():AddCounter(0x1b,2)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetCounter(0x1b)>0 and (Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.cunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0) and c:IsType(TYPE_EQUIP)  and c:IsCanAddCounter(0x1b,1) 
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ec=c:GetEquipTarget()
	c:RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(s.cunfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	if g and #g>0 then
	local tc=g:GetFirst()
		while tc do
			if tc:IsCanAddCounter(0x1b,1) then
				tc:AddCounter(0x1b,1)
			end
			tc=g:GetNext()
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1000)
	ec:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(tp,1)
	if coin==1 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end
function s.cfilter(c)
	return aux.IsCodeListed(c,75646000) and c:IsAbleToRemoveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end