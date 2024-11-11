local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
s.counter_add_list={0x100e}
function s.mfilter(c)
	return (c:IsLinkSetCard(0xc) or (c:IsLinkRace(RACE_REPTILE) and c:IsLevel(1)))
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,aux.AND(Card.IsFaceup,Card.IsAttackAbove),tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,800):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local ct=math.floor(tc:GetAttack()/800)
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x100e,1)
		sg:GetFirst():AddCounter(0x100e,1)
	end
end
