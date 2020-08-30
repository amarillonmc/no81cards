local m=82224035
local cm=_G["c"..m]
cm.name="瀚宇星皇"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)  
	c:EnableReviveLimit() 
	--extra att  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_EXTRA_ATTACK)  
	e1:SetValue(1)  
	c:RegisterEffect(e1)
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)
	--activate limit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetCondition(cm.actcon)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)
	--negate  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e4:SetCode(EVENT_CHAINING)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1)  
	e4:SetCondition(cm.negcon)   
	e4:SetTarget(cm.negtg)  
	e4:SetOperation(cm.negop)  
	c:RegisterEffect(e4)  
end
function cm.actcon(e)  
	local ph=Duel.GetCurrentPhase()  
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE  
end  
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)  
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)  
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return re:GetHandler():IsAbleToRemove() end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)  
	end  
end  