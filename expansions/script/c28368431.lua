--挽留的古之药 罪蝶镇魂歌
function c28368431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28368431.cost)
	e1:SetTarget(c28368431.target)
	e1:SetOperation(c28368431.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28368431,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)--EFFECT_FLAG_DELAY
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28368431.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28368431.sptg)
	e2:SetOperation(c28368431.spop)
	c:RegisterEffect(e2)
end
function c28368431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28368431.codefilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c28368431.thfilter(c,tp,code)
	return c:IsSetCard(0x285) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(code)  and not Duel.IsExistingMatchingCard(c28368431.codefilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c28368431.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetCode() or 0
	if chk==0 then return Duel.IsExistingMatchingCard(c28368431.thfilter,tp,LOCATION_DECK,0,1,nil,tp,code) and (Duel.GetLP(tp)>3000 or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28368431.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28368431.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,0):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	--curse
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(28368431,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c28368431.regcon)
	e1:SetOperation(c28368431.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c28368431.chkfilter(c,p)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p) and c:IsReason(REASON_DESTROY)
end
function c28368431.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28368431.chkfilter,1,nil,tp)
end
function c28368431.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28368431)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
	Duel.SetLP(tp,3000)
end
function c28368431.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c28368431.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c28368431.cfilter,nil):GetSum(Card.GetPreviousAttackOnField)+eg:Filter(c28368431.cfilter,nil):GetSum(Card.GetPreviousDefenseOnField)>=Duel.GetLP(tp) and not eg:IsContains(e:GetHandler())
end
function c28368431.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c28368431.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c28368431.cfilter,nil)
	if chk==0 then return g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,nil)
end
function c28368431.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c28368431.cfilter,nil):Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if #g>0 then
		local tc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		if not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
