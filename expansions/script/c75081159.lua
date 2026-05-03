--黄金魔女 古尔维格
local s,id,o=GetID()
function c75081159.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,75081161)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081159,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,75081159)
	e2:SetCondition(c75081159.thcon)
	e2:SetTarget(c75081159.thtg)
	e2:SetOperation(c75081159.thop)
	c:RegisterEffect(e2)  
	--Send to extra
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081159,3))
	e4:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,75081160)
	e4:SetCondition(c75081159.tecon)
	e4:SetTarget(c75081159.tetg)
	e4:SetOperation(c75081159.teop)
	c:RegisterEffect(e4) 
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
			g1:Merge(g2)
			if Duel.Destroy(g1,REASON_EFFECT)==2 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
--
function c75081159.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
function c75081159.thfilter(c)
	return c:IsSetCard(0x6754) and c:IsAbleToHand()
end
function c75081159.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081159.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75081159.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75081159.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--
function c75081159.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x6754)
end
function c75081159.tecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c75081159.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081159.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)

end
function c75081159.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75081159,5))
	local g=Duel.SelectMatchingCard(tp,c75081159.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		if g:GetFirst():IsLocation(LOCATION_HAND) and g:GetFirst():IsRelateToEffect(e) then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end