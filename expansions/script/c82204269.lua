local m=82204269
local cm=_G["c"..m]
cm.name="水银沙漏"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate) 
	c:RegisterEffect(e1) 
	--the world
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,0))  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(m,1)
	e5:SetCost(cm.skipcost)  
	e5:SetTarget(cm.skiptg)  
	e5:SetOperation(cm.skipop)  
	c:RegisterEffect(e5)  
end
function cm.thfilter(c)  
	return c:IsSetCard(0x5299) and c:IsAbleToHand()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
	end  
end  
function cm.costfilter(c)  
	return c:IsSetCard(0x5299) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()  
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
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_SKIP_TURN)  
	e1:SetTargetRange(0,1)  
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
	e1:SetCondition(cm.skipcon)  
	Duel.RegisterEffect(e1,tp)  
end  