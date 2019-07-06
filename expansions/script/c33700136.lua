--霓火慧眼
function c33700136.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33700136.con)
	e1:SetTarget(c33700136.tg)
	e1:SetOperation(c33700136.op)
	c:RegisterEffect(e1)
end
function c33700136.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r==REASON_RULE
end
function c33700136.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33700136.filter(c,e,tp)
	return c:IsSetCard(0x443) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700136.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c33700136.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(33700136,0)) then
	 local g=Duel.SelectMatchingCard(tp,c33700136.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end