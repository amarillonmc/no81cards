local m=82204269
local cm=_G["c"..m]
cm.name="水银沙漏"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m) 
	--Activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	e0:SetCost(cm.reg)
	c:RegisterEffect(e0)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop) 
	c:RegisterEffect(e1) 
	--the world
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,0))  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(1,m+10000)
	e5:SetCost(cm.skipcost)  
	e5:SetTarget(cm.skiptg)  
	e5:SetOperation(cm.skipop)  
	c:RegisterEffect(e5)  
end
cm.SetCard_01_RedHat=true 
function cm.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.thfilter(c)  
	return c.SetCard_01_RedHat and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if #g>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.costfilter(c)  
	return c.SetCard_01_RedHat and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()  
end  
function cm.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)  
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7 end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	aux.GCheckAdditional=aux.dncheck  
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,7,7)  
	aux.GCheckAdditional=nil  
	Duel.Remove(rg,POS_FACEUP,REASON_COST)  
end  
function cm.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end  
end  
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_SKIP_TURN)  
	e1:SetTargetRange(0,1)  
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
	e1:SetCondition(cm.skipcon)  
	Duel.RegisterEffect(e1,tp)  
end  