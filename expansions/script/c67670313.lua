--重兵装型女子高生・集结
function c67670313.initial_effect(c)
	--spsummon and to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67670313,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67670313)
	e1:SetTarget(c67670313.tstg)
	e1:SetOperation(c67670313.tsop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67670313,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67670313)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67670313.target)
	e2:SetOperation(c67670313.operation)
	c:RegisterEffect(e2)
end
function c67670313.thfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x1b7) and c:IsAbleToGrave() and (ft>0 or c:GetSequence()<5)
		and Duel.IsExistingMatchingCard(c67670313.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c67670313.spfilter2(c,e,tp,code)
	return c:IsSetCard(0x1b7) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67670313.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67670313.thfilter(chkc,e,tp,ft) end
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(c67670313.thfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c67670313.thfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67670313.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c67670313.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			Duel.SendtoGrave(tc,nil,REASON_EFFECT)
		end
	end
end
--special summon
function c67670313.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1b7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67670313.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c67670313.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67670313.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67670313.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67670313.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end