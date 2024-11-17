--忍者魂 上忍
function c98920503.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c98920503.thcon)
	e1:SetTarget(c98920503.thtg)
	e1:SetOperation(c98920503.thop)
	c:RegisterEffect(e1)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c98920503.discon)
	e4:SetOperation(c98920503.disop)
	c:RegisterEffect(e4)
end
function c98920503.cfilter(c,seq2)
	local seq1=c:GetSequence()
	return c:IsFaceup() and seq1==4-seq2
end
function c98920503.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c98920503.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function c98920503.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98920503.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c98920503.cfilter(c,seq2)
	local seq1=aux.SZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and seq1==4-seq2
end
function c98920503.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc== LOCATION_MZONE then seq=aux.MZoneSequence(seq) else seq=aux.SZoneSequence(seq) end
	return rp==1-tp and Duel.IsExistingMatchingCard(c98920503.cfilter,tp,LOCATION_PZONE,0,1,nil,seq)
end
function c98920503.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,98920503)
	Duel.NegateEffect(ev)
end