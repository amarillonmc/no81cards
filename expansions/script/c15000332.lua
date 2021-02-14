local m=15000332
local cm=_G["c"..m]
cm.name="内核保护 苦痛"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,15000332)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)  
	e4:SetCountLimit(1,15010332)  
	e4:SetTarget(cm.atktg)  
	e4:SetOperation(cm.atkop)  
	c:RegisterEffect(e4)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf39) and c:IsAbleToHand()
end
function cm.costfilter(c)  
	return c:IsAbleToGraveAsCost() and c:IsRace(RACE_FIEND)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.th2filter(c)  
	return c:IsSetCard(0xf39) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.th2filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.th2filter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.th2filter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)  
	end  
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler() 
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)) then return end
	--pos  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SET_POSITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.poscon)  
	e1:SetTarget(cm.postg)  
	e1:SetValue(POS_FACEUP_ATTACK)  
	tc:RegisterEffect(e1)
	--must attack  
	local e2=Effect.CreateEffect(e:GetHandler())  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_MUST_ATTACK)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)  
	tc:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)  
	e3:SetValue(cm.atklimit)  
	tc:RegisterEffect(e3) 
	tc:RegisterFlagEffect(15010332,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
end
function cm.poscon(e)  
	return e:GetHandler():IsLocation(LOCATION_MZONE) 
end  
function cm.postg(e,c)  
	return c:IsFaceup()  
end
function cm.atklimit(e,c)  
	return c==e:GetHandler()  
end