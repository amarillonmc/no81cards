--人理之诗 转身火生三昧
function c22020110.initial_effect(c)
	aux.AddCodeList(c,22020010,22020120)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020110,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1,22020110+EFFECT_COUNT_CODE_OATH)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c22020110.cost)
	e2:SetTarget(c22020110.thtg)
	e2:SetOperation(c22020110.thop)
	c:RegisterEffect(e2)
end
function c22020110.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020010)
end
function c22020110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22020110.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22020110.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Debug.Message("请各位明鉴！")
end
function c22020110.spfilter(c,e,tp)
	return c:IsCode(22020120) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c22020110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c22020110.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22020110.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c22020110.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c22020110.filter,tp,0,LOCATION_MZONE,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Debug.Message("现在，就此戳穿无法逃避的谎言——")
	local g=Duel.SelectMatchingCard(tp,c22020110.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			g:GetFirst():CompleteProcedure()
			Duel.BreakEffect()
			Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
			Debug.Message("转身火生三昧！")
		end
	end
end

