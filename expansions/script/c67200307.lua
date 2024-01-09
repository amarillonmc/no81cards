--姬狩的封缄英杰 莉莉
function c67200307.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200307,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200307)
	e1:SetCost(c67200307.sccost)
	e1:SetTarget(c67200307.sctg)
	e1:SetOperation(c67200307.scop)
	c:RegisterEffect(e1)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200307,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetTarget(c67200307.thtg)
	e3:SetOperation(c67200307.thop)
	c:RegisterEffect(e3)	  
end
function c67200307.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3674)
end
function c67200307.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200307.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200307,2))
	local g=Duel.SelectMatchingCard(tp,c67200307.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoExtraP(tc,tp,REASON_COST)
end
function c67200307.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable(REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,tp,nil)
end
function c67200307.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Group.CreateGroup()
		g:AddCard(c)
		Duel.Release(g,REASON_EFFECT)
	end
end
--
function c67200307.thfilter(c)
	return c:IsSetCard(0x3674) and not c:IsCode(67200307) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c67200307.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200307.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c67200307.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200307.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

