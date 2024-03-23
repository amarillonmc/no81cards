--雪狱之罪主 傲视万物之王
function c9911357.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9911357)
	e1:SetCondition(c9911357.thcon1)
	e1:SetTarget(c9911357.thtg)
	e1:SetOperation(c9911357.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MOVE)
	e2:SetCondition(c9911357.thcon2)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9911357.tgcon)
	e3:SetCost(c9911357.tgcost)
	e3:SetTarget(c9911357.tgtg)
	e3:SetOperation(c9911357.tgop)
	c:RegisterEffect(e3)
	if not c9911357.global_check then
		c9911357.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c9911357.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911357.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousControler(tp) and not (c:IsLocation(LOCATION_HAND) and c:IsControler(tp))
end
function c9911357.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911357.cfilter,1,nil,0) then
		Duel.RegisterFlagEffect(0,9911358,RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(c9911357.cfilter,1,nil,1) then
		Duel.RegisterFlagEffect(1,9911358,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911357.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9911357.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c9911357.cffilter1(c)
	return not c:IsPublic()
end
function c9911357.thfilter(c,cardtype)
	return c:IsSetCard(0xc956) and c:IsType(cardtype) and c:IsAbleToHand()
end
function c9911357.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	local cardtype=0
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cardtype=cardtype+TYPE_MONSTER end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then cardtype=cardtype+TYPE_SPELL end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cardtype=cardtype+TYPE_TRAP end
	if chk==0 then return Duel.IsExistingMatchingCard(c9911357.cffilter1,tp,0,LOCATION_HAND,1,nil)
		or (#g>0 and Duel.IsExistingMatchingCard(c9911357.thfilter,tp,LOCATION_DECK,0,1,nil,cardtype)) end
end
function c9911357.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9911357.thop(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local g1=Duel.GetMatchingGroup(c9911357.cffilter1,tp,0,LOCATION_HAND,nil)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=g1:RandomSelect(tp,1):GetFirst()
		if tc then
			Duel.ConfirmCards(tp,tc)
			tc:RegisterFlagEffect(9911357,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			chk=true
		end
	end
	Duel.AdjustAll()
	Duel.ShuffleHand(1-tp)
	local g2=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	local cardtype=0
	if g2:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cardtype=cardtype+TYPE_MONSTER end
	if g2:IsExists(Card.IsType,1,nil,TYPE_SPELL) then cardtype=cardtype+TYPE_SPELL end
	if g2:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cardtype=cardtype+TYPE_TRAP end
	if #g2>0 then
		local tg=Duel.GetMatchingGroup(c9911357.thfilter,tp,LOCATION_DECK,0,nil,cardtype)
		if #tg==0 then return end
		if chk then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:SelectSubGroup(tp,c9911357.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9911357.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,9911358)>0
end
function c9911357.cffilter2(c)
	return c:IsSetCard(0xc956) and not c:IsPublic()
end
function c9911357.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911357.cffilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c9911357.cffilter2,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	tc:RegisterFlagEffect(9911357,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c9911357.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local ct1=math.max(0,#g1-1)
	local ct2=math.max(0,#g2-1)
	local b1=ct1>0 and g1:IsExists(Card.IsAbleToGrave,1,nil,1-tp,nil)
	local b2=ct2>0 and g2:IsExists(Card.IsAbleToGrave,1,nil,1-tp,nil)
	if chk==0 then return Duel.IsPlayerCanSendtoGrave(1-tp) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,ct1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,ct2,0,0)
end
function c9911357.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSendtoGrave(1-tp) then return end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local ct1=math.max(0,#g1-1)
	local ct2=math.max(0,#g2-1)
	local sg=Group.CreateGroup()
	if ct1>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg1=g1:FilterSelect(1-tp,Card.IsAbleToGrave,ct1,ct1,nil,1-tp,nil)
		sg:Merge(sg1)
	end
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg2=g2:FilterSelect(1-tp,Card.IsAbleToGrave,ct2,ct2,nil,1-tp,nil)
		sg:Merge(sg2)
	end
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
