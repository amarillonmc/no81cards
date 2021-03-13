--亡语教徒 堕修女
function c99988020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)	
	e1:SetCountLimit(1,99988020)
	e1:SetCost(c99988020.cost)
	e1:SetTarget(c99988020.target)
	e1:SetOperation(c99988020.operation)
	c:RegisterEffect(e1)	
end
function c99988020.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x20df) and c:IsAbleToDeckAsCost()
end
function c99988020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988020.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99988020.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99988020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local c=e:GetHandler()
	if re and re:GetHandler():IsSetCard(0x20df) and c:IsReason(REASON_EFFECT) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c99988020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsLocation(LOCATION_MZONE) and e:GetLabel()==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(99988020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	   if #g>0 then
		 Duel.HintSelection(g)
		 Duel.Destroy(g,REASON_EFFECT)
	  end
   end
end