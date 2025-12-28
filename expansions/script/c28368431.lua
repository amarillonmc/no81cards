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
	--
	if not c28368431.global_check then
		c28368431.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		--ge1:SetCondition(c28368431.checkcon)
		ge1:SetOperation(c28368431.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28368431.ctfilter(c,p)
	return c:IsSetCard(0x285) and c:IsSummonPlayer(p) and c:IsFaceup()
end
function c28368431.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c28368431.ctfilter,1,nil,0) then Duel.RegisterFlagEffect(0,28368431,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c28368431.ctfilter,1,nil,1) then Duel.RegisterFlagEffect(1,28368431,RESET_PHASE+PHASE_END,0,1) end
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
	local val=Duel.Recover(tp,Duel.GetFlagEffect(tp,28368431)*500,REASON_EFFECT)
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
