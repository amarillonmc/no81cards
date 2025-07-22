--炯眼的燎原
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.costfilter(c,tp)
	return c:IsReleasable() and (c:IsControler(tp) and c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) or c:IsControler(1-tp) and c:IsFaceup())
end
function s.fselect(g,tp,fe)
	local ct=fe and 1 or 0
	return g:FilterCount(Card.IsControler,nil,1-tp)<=ct
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rlg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local spct=0
	local fe=Duel.IsPlayerAffectedByEffect(tp,89490080)
	if rlg:CheckSubGroup(s.fselect,1,#rlg,tp,fe) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=rlg:SelectSubGroup(tp,s.fselect,false,1,rgc,tp,fe)
		if g:IsExists(Card.IsControler,1,nil,1-tp) then
			Duel.Hint(HINT_CARD,0,89490080)
			fe:UseCountLimit(tp)
		end
		Duel.Release(g,REASON_COST)
		spct=#g
	end
	e:SetLabel(spct)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if e:GetLabel()>0 then
		e:SetCategory(e:GetCategory()|CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_REMOVE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local spct=e:GetLabel()
		if spct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,spct,nil)
			if #sg<=0 then return end
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
