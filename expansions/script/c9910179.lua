--匪魔追缉者 禁毒特工
function c9910179.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910179)
	e1:SetCondition(c9910179.spcon)
	e1:SetTarget(c9910179.sptg)
	e1:SetOperation(c9910179.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910180)
	e2:SetTarget(c9910179.thtg)
	e2:SetOperation(c9910179.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910179,ACTIVITY_CHAIN,c9910179.chainfilter)
end
function c9910179.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c9910179.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function c9910179.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910179.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsReleasableByEffect()
end
function c9910179.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.CheckReleaseGroupEx(tp,c9910179.cfilter,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
		and Duel.SelectYesNo(tp,aux.Stringid(9910179,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectReleaseGroupEx(tp,c9910179.cfilter,1,1,nil)
		if #g>0 and Duel.Release(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function c9910179.filter(c,tp,chk)
	return c:IsCode(9910181) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c9910179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.GetCustomActivityCount(9910179,tp,ACTIVITY_CHAIN)~=0
			or Duel.GetCustomActivityCount(9910179,1-tp,ACTIVITY_CHAIN)~=0
		return Duel.IsExistingMatchingCard(c9910179.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,rp,res)
	end
end
function c9910179.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetCustomActivityCount(9910179,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9910179,1-tp,ACTIVITY_CHAIN)~=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910179.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,res):GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=res and tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
