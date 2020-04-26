local m=82204209
local cm=_G["c"..m]
cm.name="川尻浩作·阵亡形态"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),6,2)
	c:EnableReviveLimit()
	--name change  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e0:SetCode(EFFECT_CHANGE_CODE)  
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)  
	e0:SetValue(82204200)  
	c:RegisterEffect(e0)
	--immune  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(cm.efilter)  
	c:RegisterEffect(e1) 
	--reg  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.con)
	e3:SetCost(cm.cost)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetCondition(cm.con2)
	e4:SetCost(cm.cost2)
	c:RegisterEffect(e4)
end
function cm.efilter(e,te)  
	local c=e:GetHandler()  
	local ec=te:GetHandler() 
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false end  
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
	end
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_TO_HAND)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(0,1)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))  
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(0,1)  
	e2:SetTarget(cm.splimit)  
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
	Duel.RegisterEffect(e2,tp)  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_DECK)  
end  