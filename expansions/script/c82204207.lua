local m=82204207
local cm=_G["c"..m]
cm.name="杀手皇后第二炸弹·枯萎穿心攻击"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e2:SetCondition(cm.handcon)  
	c:RegisterEffect(e2) 
	--to hand
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_END_PHASE)
	e4:SetRange(LOCATION_GRAVE)  
	e4:SetCountLimit(1,m) 
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)	 
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_FIRE)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("给我看这里…！")
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		e:SetLabel(1)
	end
	if e:GetLabel()~=1 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Debug.Message("刚才的爆炸不是人类…！")
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end  
	e:SetLabel(0)
end  
function cm.cfilter2(c)  
	return c:IsFaceup() and c:IsCode(82204200)  
end  
function cm.handcon(e)  
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.thfilter(c)  
	return aux.IsCodeListed(c,82204200) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToHand() and c:IsFaceup()
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  