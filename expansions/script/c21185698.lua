--阿巴阿巴捣乱乱草人
function c21185698.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21185698)
	e1:SetTarget(c21185698.tg)
	e1:SetOperation(c21185698.op)
	c:RegisterEffect(e1)
end
function c21185698.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,2,0,0)
end
function c21185698.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g<=1 then return end
		local tg=g:RandomSelect(tp,2)
		if #tg==2 then
		Duel.HintSelection(tg)
			for tc in aux.Next(tg) do			
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end