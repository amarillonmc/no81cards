function c10111148.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6a),4,2)
	c:EnableReviveLimit()
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111148,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10111148.retcost)
	e1:SetTarget(c10111148.rettg)
	e1:SetOperation(c10111148.retop)
	c:RegisterEffect(e1)
    	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c10111148.dircon)
	c:RegisterEffect(e2)
    end
function c10111148.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10111148.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c10111148.hfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c10111148.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local ct1=g:FilterCount(c10111148.hfilter,nil,1-tp)
	if ct1==0 then return end
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct1*300,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c10111148.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10111148.dircon(e)
	return not Duel.IsExistingMatchingCard(c10111148.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end