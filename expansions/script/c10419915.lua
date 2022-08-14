--暗金教
local m=10419915
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--spsummon (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	--e2:SetCost(cm.cost)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.drcon)
	e5:SetTarget(cm.drtg)
	e5:SetOperation(cm.drop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not cm.Potion(re:GetHandler())
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0
end
--function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--  local g=Duel.GetReleaseGroup(tp)
--  if chk==0 then return g:GetCount()>0 end
--  Duel.Release(g,REASON_COST)
--end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp)
	if g:GetCount()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.Release(g,REASON_EFFECT)~=0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.Potion(re:GetHandler()) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	cm[re:GetOwnerPlayer()]=cm[re:GetOwnerPlayer()]+1
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	if cm[re:GetOwnerPlayer()]==0 then cm[re:GetOwnerPlayer()]=1 end
	cm[re:GetOwnerPlayer()]=cm[re:GetOwnerPlayer()]-1
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=cm[tp]
	if chk==0 then return d>0 and Duel.IsPlayerCanDraw(tp,d) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,3,3,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end

