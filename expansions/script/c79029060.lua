--龙门·近卫干员-诗怀雅
function c79029060.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2) 
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55285840,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c79029060.mattg)
	e1:SetOperation(c79029060.matop)
	c:RegisterEffect(e1)  
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79029060.desreptg)
	e2:SetValue(c79029060.desrepval)
	e2:SetOperation(c79029060.desrepop)
	c:RegisterEffect(e2) 
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(69610924,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c79029060.cost)
	e3:SetOperation(c79029060.operation)
	c:RegisterEffect(e3)
end
function c79029060.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function c79029060.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		Duel.Overlay(c,g)
	end
end
function c79029060.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029060.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029060.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,79029096)
end
function c79029060.desrepval(e,c)
	return c79029060.repfilter(c,e:GetHandlerPlayer())
end
function c79029060.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,1-tp,79029060)
end
function c79029060.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029060.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029060.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end