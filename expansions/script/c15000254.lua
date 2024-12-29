local m=15000254
local cm=_G["c"..m]
cm.name="永寂之末路：奈喀纳伊"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.negcon)
	--e1:SetCost(cm.negcost)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--actlimit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetValue(1)  
	e3:SetCondition(cm.actcon)  
	c:RegisterEffect(e3)
	--XyzSummon 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetOperation(cm.regop)  
	c:RegisterEffect(e4)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and Duel.IsChainDisablable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_LINK)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.actcon(e)  
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()  
end 
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_DECKBOT)  
		e:GetHandler():RegisterEffect(e1,true)
	end
end