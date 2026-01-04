--闪耀的紫焰光 幽谷雾子
function c28316051.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316051)
	e1:SetCondition(c28316051.spcon)
	e1:SetTarget(c28316051.sptg)
	e1:SetOperation(c28316051.spop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316051,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316051)
	e2:SetCondition(c28316051.tgcon)
	--e2:SetTarget(c28316051.tgtg)
	e2:SetOperation(c28316051.tgop)
	c:RegisterEffect(e2)
end
function c28316051.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c28316051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
end
function c28316051.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	if Duel.GetLP(tp)>3000 then Duel.Damage(tp,2000,REASON_EFFECT) end
end
function c28316051.chkfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c28316051.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c28316051.chkfilter,1,nil,tp)
end
function c28316051.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28316051.cfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceupEx()
end
function c28316051.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(28316051,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c28316051.regop)
		c:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(c28316051.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if Duel.GetLP(tp)<=3000 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(28316051,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,2,nil)
		if sg:FilterCount(Card.IsAbleToRemove,nil)<#sg or Duel.SelectOption(tp,aux.Stringid(28316051,3),1192)==0 then
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c28316051.ffilter(c,p)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(p,true,true) and aux.NecroValleyFilter()(c)
end
function c28316051.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetPreviousControler()
	local g=Duel.GetMatchingGroup(c28316051.ffilter,p,LOCATION_GRAVE,0,nil,p)
	if c:IsReason(REASON_DESTROY) and #g>0 then
		Duel.Hint(HINT_CARD,0,28316051)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
		local tc=g:Select(p,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local fc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,p,p,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(p,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,p,p,Duel.GetCurrentChain())
	end
	e:Reset()
end
