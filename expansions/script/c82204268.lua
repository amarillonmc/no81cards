local m=82204268
local cm=_G["c"..m]
cm.name="生命护符"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--halve damage  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCode(EFFECT_CHANGE_DAMAGE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,0)  
	e2:SetCondition(cm.condition)  
	e2:SetValue(cm.val)  
	c:RegisterEffect(e2)  
	--recover  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_RECOVER)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetCountLimit(1,14169845)  
	e3:SetTarget(cm.rectg)  
	e3:SetOperation(cm.recop)  
	c:RegisterEffect(e3)  
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5299) 
end  
function cm.condition(e)  
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)  
end  
function cm.val(e,re,dam,r,rp,rc)  
	return math.floor(dam/2)  
end  
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1500)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)  
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end  