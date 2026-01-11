--闪耀的紫焰光 白濑咲耶
function c28317560.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28317560)
	e1:SetCondition(c28317560.spcon)
	e1:SetCost(c28317560.cost)
	e1:SetTarget(c28317560.sptg)
	e1:SetOperation(c28317560.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28317560,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38317560)
	e2:SetCondition(c28317560.spcon2)
	e2:SetCost(c28317560.cost)
	--e2:SetTarget(c28317560.sptg2)
	e2:SetOperation(c28317560.spop2)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function c28317560.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c28317560.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
end
function c28317560.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	if Duel.GetLP(tp)>3000 then Duel.Damage(tp,2000,REASON_EFFECT) end
end
function c28317560.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c28317560.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c28317560.cfilter,1,nil,tp)
end
function c28317560.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x283) and aux.NecroValleyFilter()(c) or c:IsLocation(LOCATION_HAND) and c:IsLevel(3)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28317560.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28317560.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then c28317560.effop(c) end
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28317560.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(28317560,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28317560.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c28317560.effop(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28317560,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
	e1:SetOperation(c28317560.regop)
	c:RegisterEffect(e1)
end
function c28317560.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetPreviousControler()
	local g=Duel.GetMatchingGroup(c28317560.spfilter,p,LOCATION_HAND,0,nil,e,p)
	if c:IsReason(REASON_DESTROY) and #g>0 and Duel.GetMZoneCount(p)>0 then
		Duel.Hint(HINT_CARD,0,28317560)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local tc=g:Select(p,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
	end
	e:Reset()
end
function c28317560.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28317560) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28317560,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28317560,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28384553,e,0,0,0,0)
end
