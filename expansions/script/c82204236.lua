local m=82204236
local cm=_G["c"..m]
cm.name="虚妄灵体 异界之门番"
function cm.initial_effect(c)
	--flip check
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_FLIP)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetOperation(cm.chkop)  
	c:RegisterEffect(e1) 
	--flip  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.flipcon)  
	e2:SetCost(cm.flipcost)  
	e2:SetTarget(cm.fliptg)  
	e2:SetOperation(cm.flipop)  
	c:RegisterEffect(e2) 
	--pos
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_POSITION)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EVENT_PHASE+PHASE_END)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetTarget(cm.postg)  
	e3:SetOperation(cm.posop)  
	c:RegisterEffect(e3)   
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetValue(200)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	c:RegisterEffect(e1)
end  
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)  
	return rc~=e:GetHandler()
end  
function cm.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() end  
	local pos=Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)  
	Duel.ChangePosition(c,pos)
end  
function cm.thfilter(c,e,tp)  
	return c:IsSetCard(0x6298) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	return tc and tc:IsRelateToBattle()  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetHandler():GetBattleTarget()  
	Duel.Hint(HINT_CARD,0,m)  
	Duel.SendtoGrave(tc,REASON_EFFECT)  
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsCanTurnSet() end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)  
	end  
end  