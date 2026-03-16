--闪烁初星 花海咲季·校园模式!!
function c71201210.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71201210,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11201210)
	e1:SetCost(c71201210.spcost)
	e1:SetTarget(c71201210.sptg)
	e1:SetOperation(c71201210.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71201210,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,71201210)
	e2:SetCondition(c71201210.con)
	e2:SetTarget(c71201210.tg)
	e2:SetOperation(c71201210.op)
	c:RegisterEffect(e2)
end
function c71201210.costfilter(c,e,tp)
	return c:IsSetCard(0x7121) and not c:IsPublic()
end
function c71201210.thfilter(c,code)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and not c:IsCode(code)
end
function c71201210.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c71201210.costfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c71201210.costfilter,tp,LOCATION_HAND,0,1,1,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function c71201210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local sc=e:GetLabelObject()
	if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	end
end
function c71201210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	if c:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if sc:IsRelateToChain() then
			if sc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(71201210,1)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				Duel.Recover(tp,500,REASON_EFFECT)
			elseif sc:IsType(TYPE_SPELL+TYPE_TRAP) and sc:IsAbleToRemove() and Duel.IsExistingMatchingCard(c71201210.thfilter,tp,LOCATION_DECK,0,1,nil,sc:GetCode())
				and Duel.SelectYesNo(tp,aux.Stringid(71201210,2)) then
				Duel.BreakEffect()
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c71201210.thfilter,tp,LOCATION_DECK,0,1,1,nil,sc:GetCode())
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function c71201210.cfilter(c)
	return c:IsSetCard(0x7121) and c:IsFaceup()
end
function c71201210.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and Duel.IsExistingMatchingCard(c71201210.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c71201210.filter(c)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c71201210.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201210.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c71201210.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71201210.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1190,1192)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end