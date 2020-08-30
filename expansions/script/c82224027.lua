local m=82224027
local cm=_G["c"..m]
cm.name="魔能机甲 斯德鲁"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2)  
	c:EnableReviveLimit() 
	--indestructable  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e1:SetValue(cm.indval)  
	c:RegisterEffect(e1) 
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(cm.condition)  
	e2:SetTarget(cm.target)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)  
end
function cm.indval(e,c)  
	return not c:IsType(TYPE_LINK)  
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)  
	return (bit.band(loc,LOCATION_HAND)~=0 or bit.band(loc,LOCATION_GRAVE)~=0) and re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local rc=re:GetHandler()  
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end  
end  