--神威骑士，超级转变！
function c24501021.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c24501021.excondition)
	e0:SetDescription(aux.Stringid(24501021,0))
	c:RegisterEffect(e0)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24501021,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24501021.sytg)
	e1:SetOperation(c24501021.syop)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501021,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c24501021.sptg)
	e2:SetOperation(c24501021.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c24501021.cost)
	e3:SetTarget(c24501021.thtg)
	e3:SetOperation(c24501021.thop)
	c:RegisterEffect(e3)
end
function c24501021.exfilter(c)
	return c:IsCode(24501036) and c:IsFaceup()
end
function c24501021.excondition(e)
	return Duel.IsExistingMatchingCard(c24501021.exfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c24501021.tdfilter(c)
	return (c:IsRace(RACE_MACHINE) or c:IsType(TYPE_TUNER)) and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function c24501021.gcheck(sg,e,tp)
	return sg:FilterCount(Card.IsType,nil,TYPE_TUNER)==1 and sg:IsExists(Card.IsSetCard,1,nil,0x501) and Duel.IsExistingMatchingCard(c24501021.syfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg:GetSum(Card.GetLevel))
end
function c24501021.syfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsLevel(lv)
		and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c24501021.sytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24501021.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 and g:CheckSubGroup(c24501021.gcheck,2,#g,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24501021.syop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24501021.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,c24501021.gcheck,false,2,#g,e,tp)
	if #tg==0 then return end
	local lv=tg:GetSum(Card.GetLevel)
	aux.PlaceCardsOnDeckBottom(tp,tg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c24501021.syfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c24501021.tfilter(c,e,tp)
	return c:IsSetCard(0x501) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c24501021.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c24501021.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c24501021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24501021.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c24501021.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c24501021.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24501021.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c24501021.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel()):GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end
function c24501021.costfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToDeckAsCost()
end
function c24501021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501021.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24501021.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c24501021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501021.tdfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c24501021.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,c)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24501021.tdfilter2),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24501021,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
