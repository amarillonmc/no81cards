--光道抹灭者 布莱德
function c98920144.initial_effect(c)
 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920144,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920144)
	e1:SetCondition(c98920144.spcon)
	e1:SetTarget(c98920144.sptg)
	e1:SetOperation(c98920144.spop)
	c:RegisterEffect(e1)
 --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(98920144,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920144.discon)
	e2:SetTarget(c98920144.distg)
	e2:SetOperation(c98920144.disop)
	c:RegisterEffect(e2)
end
function c98920144.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c98920144.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c98920144.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c98920144.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsPlayerCanSendtoGrave(1-tp)
		and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c98920144.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local sg=g:FilterSelect(1-tp,Card.IsAbleToGrave,ct,ct,nil,1-tp)
		Duel.Destroy(sg,REASON_RULE)
	end
end