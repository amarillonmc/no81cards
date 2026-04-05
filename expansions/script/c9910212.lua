--天空漫步者-拦截
function c9910212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910212.target)
	e1:SetOperation(c9910212.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910212,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910212)
	e2:SetCondition(c9910212.rmcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910212.rmtg)
	e2:SetOperation(c9910212.rmop)
	c:RegisterEffect(e2)
end
function c9910212.seqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c9910212.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910212.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910212.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910212,0))
	Duel.SelectTarget(tp,c9910212.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910212.posfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanTurnSet()
end
function c9910212.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local count=2
	while count>0 do
		Duel.AdjustAll()
		if tc:IsRelateToEffect(e) and tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
			and (count==2 or Duel.SelectYesNo(tp,aux.Stringid(9910212,1))) then
			if count<2 then Duel.BreakEffect() end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(tc,nseq)
			local tg=tc:GetColumnGroup():Filter(c9910212.posfilter,nil,tp)
			if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910212,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local sg=tg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			end
			count=count-1
		else
			count=0
		end
	end
end
function c9910212.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local race,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and bit.band(race,RACE_PSYCHO)~=0 and bit.band(LOCATION_GRAVE,loc)~=0
end
function c9910212.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9910212.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
