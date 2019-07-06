--coded by Lyris
--Heavenly Maid Misuzu
function c33700197.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 3 "Heavenly Maid" Monsters, with no more than 1 Token
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x444),3,3,function(g) return g:FilterCount(Card.IsType,nil,TYPE_TOKEN)<=2 end)
	--When this card is Special Summoned, send all monsters linked to this card to the GY.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(e:GetHandler():GetLinkedGroup(),REASON_EFFECT) end)
	c:RegisterEffect(e4)
	--Make your opponent send any non-"Heavenly Maid" monster is summoned or Special Summoned to a Monster Zone this card to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(eg:Filter(function(c,g) return g:IsContains(c) and not c:IsSetCard(0x444) end,nil,e:GetHandler():GetLinkedGroup()),REASON_RULE) end)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Cannot be destroyed by Card Effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--If this card is destroyed, you can Special Summon 1 "Heavenly Maid" monster, except "Heavenly Maid Misuzu" from your Hand or GY in Attack Position.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c33700197.target)
	e3:SetOperation(c33700197.activate)
	c:RegisterEffect(e3)
end
function c33700197.filter(c,e,tp)
	return c:IsSetCard(0x444) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(33700197)
end
function c33700197.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33700197.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33700197.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33700197.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
