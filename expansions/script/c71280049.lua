--癔动囚徒 幻塔
function c71280049.initial_effect(c)
	--destory and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71280049,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71280049)
	e1:SetCost(c71280049.descost)
	e1:SetTarget(c71280049.destg)
	e1:SetOperation(c71280049.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71280049,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c71280049.sptg)
	e2:SetOperation(c71280049.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71280049,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,11280049)
	e3:SetTarget(c71280049.thtg)
	e3:SetOperation(c71280049.thop)
	c:RegisterEffect(e3)
end
function c71280049.costfilter(c,ec,e,tp)
	if not c:IsSetCard(0x8911) or not c:IsType(TYPE_MONSTER) or c:IsPublic() then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(c71280049.desspfilter,1,nil,g,e,tp)
end
function c71280049.desspfilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsDestructable,1,c,e)
end
function c71280049.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c71280049.costfilter,tp,LOCATION_HAND,0,1,c,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c71280049.costfilter,tp,LOCATION_HAND,0,1,1,c,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function c71280049.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c71280049.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local g=Group.FromCards(c,sc)
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=fg:FilterSelect(tp,c71280049.desspfilter,1,1,nil,fg,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Destroy(g-sg,REASON_EFFECT)
	end
end
function c71280049.spfilter(c,e,tp)
	return c:IsSetCard(0x8911) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71280049.descfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x8911)
end
function c71280049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71280049.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c71280049.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280049.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(c71280049.descfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,c71280049.descfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c71280049.thfilter(c,e,tp)
	if not (c:IsSetCard(0x8911) and c:IsType(TYPE_MONSTER)) then return false end
	return c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71280049.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280049.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c71280049.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280049.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local op=aux.SelectFromOptions(tp,
			{tc:IsAbleToHand(),1190},
			{Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false),1152})
		if op==1 then Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif op==2 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
end