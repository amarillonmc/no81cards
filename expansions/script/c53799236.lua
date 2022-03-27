local m=53799236
local cm=_G["c"..m]
cm.name="我战我自己"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.tfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.bfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function cm.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and c:IsPosition(POS_FACEUP_ATTACK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 and tc:IsPosition(POS_FACEUP_ATTACK) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local bc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,0,LOCATION_MZONE,1,1,nil,tc:GetCode()):GetFirst()
			if bc then Duel.CalculateDamage(tc,bc,true) end
		end
	end
end
