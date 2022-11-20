--食人宝箱鬼
function c10113012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit() 
	--ha
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113012,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11)
	e1:SetCost(c10113012.cost)
	e1:SetOperation(c10113012.op)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113012,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10113012)
	e2:SetCondition(c10113012.setcon)
	e2:SetTarget(c10113012.settg)
	e2:SetOperation(c10113012.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c10113012.setcon2)
	e3:SetTarget(c10113012.settg2)
	c:RegisterEffect(e3)
end
function c10113012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
   local rc=Duel.GetAttacker()
   if chk==0 then return rc:IsAbleToHand() or rc:IsLocation(LOCATION_HAND) end
   e:SetLabelObject(rc)
   if not rc:IsLocation(LOCATION_HAND) then
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,rc,1,0,0)
   end
end
function c10113012.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
   local rc=re:GetHandler()
   if chk==0 then return rc:IsAbleToHand() end
   e:SetLabelObject(rc)
   if not rc:IsLocation(LOCATION_HAND) then
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,rc,1,0,0)
   end
end
function c10113012.setop(e,tp,eg,ep,ev,re,r,rp)
   local rc=e:GetLabelObject()
   if rc:IsControler(1-tp) and (rc:IsAbleToHand() or rc:IsLocation(LOCATION_HAND)) then
	  Duel.SendtoHand(rc,tp,REASON_EFFECT)
   end
end
function c10113012.setcon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetAttacker():IsControler(1-tp)
end
function c10113012.setcon2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler()) 
end
function c10113012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10113012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c10113012.atlimit)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c10113012.tgtg)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(aux.tgoval)
		c:RegisterEffect(e2)
	end
end
function c10113012.tgtg(e,c)
	return c~=e:GetHandler()
end
function c10113012.atlimit(e,c)
	return c~=e:GetHandler()
end
