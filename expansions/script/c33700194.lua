--coded by Lyris
--Heavenly Maid Fuuko
function c33700194.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 5 "Heavenly Maid" monsters, with no more than 2 Tokens.
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x444),5,5,c33700194.linkchk)
	--When this card is Special Summoned, send all monsters linked to this card to the GY.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c33700194.tgop)
	c:RegisterEffect(e4)
	--Make your opponent send any non-"Heavenly Maid" monster is summoned or Special Summoned to a Monster Zone this card to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c33700194.spcost)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Cannot be destroyed by card effects that target this card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33700194.efilter)
	c:RegisterEffect(e2)
	--If this card would be destroyed, you can send 1 "Heavenly Maid" monster you control to the GY instead.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c33700194.desreptg)
	c:RegisterEffect(e3)
end
function c33700194.linkchk(g)
	return g:FilterCount(Card.IsType,nil,TYPE_TOKEN)<=2
end
function c33700194.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=c:GetLinkedGroup()
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c33700194.spcost(e,tp,eg,ep,ev,re,r,rp)
	local cg=eg:Filter(function(c,g) return g:IsContains(c) and not c:IsSetCard(0x444) end,nil,e:GetHandler():GetLinkedGroup())
	Duel.SendtoGrave(cg,REASON_RULE)
end
function c33700194.efilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g:IsContains(c)
end
function c33700194.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x444)
end
function c33700194.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700194.repfilter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c33700194.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end
