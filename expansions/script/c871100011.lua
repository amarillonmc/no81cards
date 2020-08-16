--青铜幼龙
function c871100011.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(871100011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c871100011.sptg)
	e1:SetOperation(c871100011.spop)
	c:RegisterEffect(e1)
------
end
function c871100011.filter1(c,tp,mc)
	local g=Group.FromCards(c)
	if mc then g:AddCard(mc) end
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) and c:IsSetCard(0xfec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,g)>0
end
function c871100011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c871100011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c871100011.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
------
