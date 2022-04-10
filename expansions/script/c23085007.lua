--暗黑界的魔王 雷登
function c23085007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetDescription(aux.Stringid(23085007,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c23085007.cost)
	e1:SetTarget(c23085007.target)
	e1:SetOperation(c23085007.operation)
	c:RegisterEffect(e1)
	--indes
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e01:SetValue(1)
	e01:SetCondition(c23085007.ctcon)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e02)
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_SINGLE)
	e03:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e03:SetRange(LOCATION_MZONE)
	e03:SetCode(EFFECT_IMMUNE_EFFECT)
	e03:SetCondition(c23085007.ctcon2)
	e03:SetValue(c23085007.efilter)
	c:RegisterEffect(e03)
	--tigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c23085007.reptg)
	e3:SetOperation(c23085007.repop)
	e3:SetValue(c23085007.repval)
	c:RegisterEffect(e3)
end
function c23085007.ctfilter(c)
	return c:IsSetCard(0x6) and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c23085007.ctcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c23085007.ctfilter,1,nil) and e:GetHandlerPlayer()==Duel.GetTurnPlayer()
end
function c23085007.ctcon2(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c23085007.ctfilter,1,nil) and e:GetHandlerPlayer()~=Duel.GetTurnPlayer()
end
function c23085007.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c23085007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c23085007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23085007.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	if h1==0 then return false end
	Duel.BreakEffect() 
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end

function c23085007.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
		and c:GetDestination()==LOCATION_GRAVE and not c:IsLocation(LOCATION_HAND)
end
function c23085007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_DISCARD)==0 
		and e:GetHandler():IsAbleToRemove() and eg:IsExists(c23085007.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(23085007,1)) then
		local g=eg:Filter(c23085007.repfilter,1,nil,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_DISCARD)
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then 
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1 then local ct=1 end
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,ct,ct,REASON_EFFECT+REASON_DISCARD) 
		end
		return true
	else return false end
end
function c23085007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c23085007.repval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
end
