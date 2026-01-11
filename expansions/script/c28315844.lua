--闪耀的紫焰光 三峰结华
function c28315844.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315844)
	e1:SetCondition(c28315844.spcon)
	e1:SetCost(c28315844.cost)
	e1:SetTarget(c28315844.sptg)
	e1:SetOperation(c28315844.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315844,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38315844)
	e2:SetCondition(c28315844.descon)
	e2:SetCost(c28315844.cost)
	--e2:SetTarget(c28315844.destg)
	e2:SetOperation(c28315844.desop)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function c28315844.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c28315844.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
end
function c28315844.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	if Duel.GetLP(tp)>3000 then Duel.Damage(tp,2000,REASON_EFFECT) end
end
function c28315844.descon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and p==tp--re:GetActivateLocation()
end
function c28315844.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28315844.gcheck(g)
	return g:FilterCount(Card.IsControler,nil,0)<=1 and g:FilterCount(Card.IsControler,nil,1)<=1
end
function c28315844.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then c28315844.effop(c) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.GetLP(tp)<=3000 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(28315844,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:SelectSubGroup(tp,c28315844.gcheck,false,1,2)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c28315844.effop(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315844,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
	e1:SetOperation(c28315844.regop)
	c:RegisterEffect(e1)
end
function c28315844.regcheck(g)
	return (g:FilterCount(Card.IsControler,nil,0)==1 or Duel.GetFieldGroup(0,LOCATION_ONFIELD,0)==0)
		and (g:FilterCount(Card.IsControler,nil,1)==1 or Duel.GetFieldGroup(1,LOCATION_ONFIELD,0)==0)
end
function c28315844.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetPreviousControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if c:IsReason(REASON_DESTROY) and #g>0 then-- and Duel.SelectYesNo(p,aux.Stringid(28315844,2))
		Duel.Hint(HINT_CARD,0,28315844)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
		local sg=g:SelectSubGroup(p,c28315844.regcheck,false,1,2)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	e:Reset()
end
function c28315844.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28315844) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28315844,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28315844,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28384553,e,0,0,0,0)
end
