--虚妄的升华
function c71280036.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,71280036+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c71280036.condition)
	e1:SetTarget(c71280036.target)
	e1:SetOperation(c71280036.activate)
	c:RegisterEffect(e1)
	--act in deck
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(c71280036.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e1)
	e3:SetTarget(c71280036.actarget)
	e3:SetOperation(c71280036.costop)
	c:RegisterEffect(e3)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(71280036,0))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCondition(c71280036.remcon)
	e6:SetTarget(c71280036.remtg)
	e6:SetOperation(c71280036.remop)
	c:RegisterEffect(e6)
end
function c71280036.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (aux.IsCodeOrListed(c,97403510) or c:IsCode(23998625) or c:IsCode(47017574))
end
function c71280036.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71280036.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c71280036.filter(c)
	return c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c71280036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280036.filter,rp,0,LOCATION_HAND+LOCATION_DECK,1,nil) end
end
function c71280036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c71280036.repop)
end
function c71280036.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,c71280036.filter,tp,0,LOCATION_HAND+LOCATION_DECK,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c71280036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,71280033) and Duel.GetFlagEffect(tp,71280033)==0 end
	Duel.RegisterFlagEffect(tp,71280033,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c71280036.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c71280036.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c71280036.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c71280036.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function c71280036.rfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function c71280036.tdfilter(c,tp)
	return c:IsFaceupEx()
end
function c71280036.spfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71280036.remcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71280036.rfilter,1,nil,tp)
end
function c71280036.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c71280036.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not aux.NecroValleyFilter()(c) then return end
	local tdg=Group.CreateGroup()
	tdg:AddCard(c)
	local ct=eg:FilterCount(c71280036.rfilter,nil,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71280036.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if ct>1 and #g>0 then
		local sg=g:Select(tp,1,ct-1,nil)
		tdg:Merge(sg)
	end
	Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local cg=Duel.GetOperatedGroup()
	if cg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local cct=cg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if cct>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71280036.spfilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(71280036,2)) then
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280036.spfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end