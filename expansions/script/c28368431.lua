--挽留的古之药 罪蝶镇魂歌
function c28368431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28368431.cost)
	e1:SetOperation(c28368431.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28368431.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28368431.thtg)
	e2:SetOperation(c28368431.thop)
	c:RegisterEffect(e2)
	--
	Duel.AddCustomActivityCounter(28368431,ACTIVITY_SPSUMMON,c28368431.counterfilter)
end
function c28368431.counterfilter(c)
	return not c:IsSetCard(0x285)
end
function c28368431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28368431.activate(e,tp,eg,ep,ev,re,r,rp)
	--recover
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	--e1:SetCondition(c28368431.regcon)
	e1:SetOperation(c28368431.regop)
	Duel.RegisterEffect(e1,tp)
end
function c28368431.setfilter(c,e,p)
	return c:IsSetCard(0x285) and (c:IsSSetable() or Duel.GetMZoneCount(p)>0 and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE))
end
function c28368431.gcheck(g,tp)
	local mt=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mt and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1 and g:FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=st
end
function c28368431.regop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.Recover(tp,Duel.GetCustomActivityCount(28368431,tp,ACTIVITY_SPSUMMON)*500,REASON_EFFECT)
	local ct=math.floor(val/1500)
	local g=Duel.GetMatchingGroup(c28368431.setfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(28368431,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,c28368431.gcheck,false,1,ct,tp)
		local mg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
		if #mg>0 then
			sg:Sub(mg)
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,mg)
		end
		Duel.SSet(tp,sg)
	end
end
function c28368431.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c28368431.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c28368431.cfilter,nil):GetSum(Card.GetPreviousAttackOnField)+eg:Filter(c28368431.cfilter,nil):GetSum(Card.GetPreviousDefenseOnField)>=Duel.GetLP(tp) and not eg:IsContains(e:GetHandler())
end
function c28368431.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c28368431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c28368431.cfilter,nil)
	if chk==0 then return g:IsExists(Card.IsAbleToHand,1,nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,nil)
end
function c28368431.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c28328484.cfilter,nil):Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if #g>0 then
		local tc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
