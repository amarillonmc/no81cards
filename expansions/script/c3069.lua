--祭礼魔导商 柯特·蒂姆
function c3069.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1012),6,2)
	c:EnableReviveLimit()
	--immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c3069.efilter)
    c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3069,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,3069)
	e2:SetTarget(c3069.thtg)
	e2:SetOperation(c3069.thop)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3069,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,3070)
	e3:SetCost(c3069.ovcost)
	e3:SetTarget(c3069.ovtg)
	e3:SetOperation(c3069.ovop)
	c:RegisterEffect(e3)
end	
function c3069.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c3069.cfilter(c)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_SPELL)
end
function c3069.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c3069.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(c3069.cfilter,tp,LOCATION_DECK,0,2,nil,e,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(3069,1),aux.Stringid(3069,2))
		e:SetLabel(opt)
		e:GetHandler():RemoveOverlayCard(tp,opt+1,opt+1,REASON_COST)
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(3069,1))
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		e:SetLabel(0)
	else
		Duel.SelectOption(tp,aux.Stringid(3069,2))
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
		e:SetLabel(1)
	end
end
function c3069.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
	    g=Duel.SelectMatchingCard(tp,c3069.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,c3069.cfilter,tp,LOCATION_DECK,0,2,2,nil)
	end
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c3069.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c3069.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_SZONE,1,nil,TYPE_SPELL+TYPE_TRAP) end
end
function c3069.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_SZONE,1,2,nil,TYPE_SPELL+TYPE_TRAP)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end