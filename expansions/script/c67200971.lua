--奥山修正者 曦光
function c67200971.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200791,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c67200971.mvtg)
	e1:SetOperation(c67200971.mvop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200791,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,67200791)
	e2:SetTarget(c67200971.mvtg2)
	e2:SetOperation(c67200971.mvop2)
	c:RegisterEffect(e2)
end
function c67200971.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ac=c:GetBattleTarget()
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return ac~=nil and mc>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c67200971.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE,1-tp)
		end
	end
end
function c67200971.filter2(c,tp)
	return not c:IsCode(67200971) and c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c67200971.mvtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200971.filter2,tp,LOCATION_EXTRA,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200971.mvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200971.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c67200971.tgfilter(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c67200971.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return mc>0 or g and g:IsExists(c67200971.tgfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_HAND)
end
function c67200971.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
end