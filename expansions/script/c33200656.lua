--电子音姬 Hardcore
function c33200656.initial_effect(c)
	c:SetSPSummonOnce(33200656)
	aux.AddXyzProcedureLevelFree(c,c33200656.mfilter,c33200656.xyzcheck,2,99)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200656,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200656)
	e1:SetCondition(c33200656.descon)
	e1:SetTarget(c33200656.destg)
	e1:SetOperation(c33200656.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200656,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200657)
	e2:SetTarget(c33200656.tgtg)
	e2:SetOperation(c33200656.tgop)
	c:RegisterEffect(e2)
end

function c33200656.mfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c33200656.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
--e1
function c33200656.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33200656.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=e:GetHandler():GetOverlayGroup():GetCount()-1
	if dc<1 then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,dc,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,dc,0,LOCATION_ONFIELD)
end
function c33200656.desop(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetHandler():GetOverlayGroup():GetCount()-1
	if dc<1 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,dc,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--e2
function c33200656.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33200656.tgfilter(c)
	return c:IsSetCard(0xa32a) and c:IsAbleToGrave()
end
function c33200656.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200656.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33200656.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33200656.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end