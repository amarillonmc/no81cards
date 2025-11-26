local m=4878351
local cm=_G["c"..m]
function cm.initial_effect(c)
 aux.AddCodeList(c,4878196)
 c:SetUniqueOnField(1,0,m)
  c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,4878196,cm.matfilter1,cm.matfilter2,nil)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetCondition(cm.ddcon)
	e4:SetTarget(cm.ddtg)
	e4:SetOperation(cm.ddop)
	c:RegisterEffect(e4)
end
function cm.ddcon(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:IsSummonLocation(LOCATION_EXTRA)
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetBaseAttack())
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() and Duel.Release(bc,REASON_EFFECT)>0 then
		local dam=bc:GetBaseAttack()
		if dam>0 then Duel.Damage(p,dam,REASON_EFFECT) end
	end
end
function cm.tdfilter(c)
	return (c:IsSetCard(0xae5a) or c:IsSetCard(0xae49)) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if chk==0 then return  g:CheckSubGroup(aux.TRUE,3,3) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	   local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,3,3)
	 if sg then
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 
	and  c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.matfilter1(c)
	return c:IsType(TYPE_FUSION)
end
function cm.matfilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil)
	  if Duel.NegateActivation(ev) and  #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.Release(sg,REASON_EFFECT)
	end
end