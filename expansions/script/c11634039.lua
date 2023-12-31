local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),2)
	local e_sp=Effect.CreateEffect(c)
	e_sp:SetDescription(aux.Stringid(id,0))
	e_sp:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e_sp:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e_sp:SetCode(EVENT_SPSUMMON_SUCCESS)
	e_sp:SetProperty(EFFECT_FLAG_DELAY)
	e_sp:SetCountLimit(1,id)
	e_sp:SetCondition(s.condition)
	e_sp:SetTarget(s.target)
	e_sp:SetOperation(s.operation)
	c:RegisterEffect(e_sp)
	local e_mtchk=Effect.CreateEffect(c)
	e_mtchk:SetType(EFFECT_TYPE_SINGLE)
	e_mtchk:SetCode(EFFECT_MATERIAL_CHECK)
	e_mtchk:SetValue(s.valcheck)
	e_mtchk:SetLabelObject(e_sp)
	c:RegisterEffect(e_mtchk)
	local e_atk=Effect.CreateEffect(c)
	e_atk:SetDescription(aux.Stringid(id,2))
	e_atk:SetCategory(CATEGORY_RELEASE)
	e_atk:SetType(EFFECT_TYPE_IGNITION)
	e_atk:SetRange(LOCATION_MZONE)
	e_atk:SetCountLimit(1,id+o)
	e_atk:SetTarget(s.rltg)
	e_atk:SetOperation(s.rlop)
	c:RegisterEffect(e_atk)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,id) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter(c,e,tp,zone)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp,zone)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)~=0 and e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rlf(c,tp,lg)
	return c:IsReleasableByEffect() and lg:IsContains(c) and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,1,c)
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,e:GetHandler():GetLinkedGroup()) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,Group.__add(e:GetHandler():GetLinkedGroup():Filter(Card.IsReleasableByEffect,nil),Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,1,nil)),2,0,0)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,s.rlf,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,c:GetLinkedGroup())
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	local atk=g1:GetSum(Card.GetAttack)
	if Duel.Release(g1,REASON_EFFECT)==0 then return end
	local atk=Duel.GetOperatedGroup():GetSum(Card.GetPreviousAttackOnField)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
