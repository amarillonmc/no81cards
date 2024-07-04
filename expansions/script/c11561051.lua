--炙热甜蜜 茜里
local m=11561051
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c11561051.lcheck)
   -- aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11561051,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11561051)
	e1:SetCondition(c11561051.ctcon)
	e1:SetOperation(c11561051.ctop)
	c:RegisterEffect(e1)
	--add dun
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561051,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11571051)
	e2:SetCost(c11561051.adcost)
	e2:SetOperation(c11561051.adop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561051,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(0xff)
	e3:SetCondition(c11561051.clcon)
	e3:SetOperation(c11561051.debug)
	c:RegisterEffect(e3)
	--link summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11561051,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,11581051)
	e4:SetCondition(c11561051.lkcon)
	e4:SetCost(c11561051.lkcost)
	e4:SetTarget(c11561051.lktg)
	e4:SetOperation(c11561051.lkop)
	c:RegisterEffect(e4)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e6:SetOperation(c11561051.effop)
 --   e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c11561051.regop)
	e5:SetLabelObject(e6)
	c:RegisterEffect(e5)
	if not c11561051.global_check then
		c11561051.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		ge1:SetTargetRange(1,1)
		ge1:SetCondition(c11561051.clcon)
		ge1:SetValue(1)
		Duel.RegisterEffect(ge1,0)
		Duel.RegisterEffect(ge1,1)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCondition(c11561051.lpcon)
		ge2:SetOperation(c11561051.Lpop)
		Duel.RegisterEffect(ge2,0)
		Duel.RegisterEffect(ge2,1)
	end
end
function c11561051.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_ZOMBIE+RACE_FIEND)
end
function c11561051.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11561051)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsCanHaveCounter(0x1) or not rc:IsType(TYPE_LINK) then return end
	rc:RegisterFlagEffect(11561051,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
	local e1=Effect.CreateEffect(rc)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11561051)
	e1:SetCondition(c11561051.coucon)
	e1:SetOperation(c11561051.couop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c11561051.coucon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11561051.couop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(11561051)
	if c:IsFaceup() and c:IsRelateToEffect(e) and ct>0 then
		c:AddCounter(0x1,ct)
	end
end
function c11561051.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetMaterialCount())
end



function c11561051.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetSequence()>4
end
function c11561051.lkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11561051.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11561051.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c11561051.debug(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	Debug.Message("护盾值"..flag)
end
function c11561051.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function c11561051.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c11561051.aqcon1)
	e1:SetOperation(c11561051.adop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11561051.aqcon1filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetReasonPlayer()==1-tp
end
function c11561051.aqcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11561051.aqcon1filter,1,nil,tp)
end
function c11561051.adop1(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	local tc=eg:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetTextAttack()
		if tatk>0 then atk=atk+tatk end
		tc=eg:GetNext()
	end
	local dun=math.floor(atk/2)
	if flag then
		Duel.SetFlagEffectLabel(tp,11561051,flag+dun)
	else
		Duel.RegisterFlagEffect(tp,11561051,RESET_EVENT+RESETS_STANDARD,0,1,dun)
	end
	e:Reset()
end
function c11561051.clcon(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	return flag and flag>0
end
function c11561051.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=0
end
function c11561051.Lpop(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,11561051)
	if Duel.GetLP(tp)<=0 and flag then
		if Duel.GetFlagEffectLabel(tp,11561051)>=2000 then
		Duel.SetLP(tp,2000)
		c:SetFlagEffectLabel(11561051,flag-2000)
		elseif Duel.GetFlagEffectLabel(tp,11561051)<2000 then
		Duel.SetLP(tp,flag)
		Duel.SetFlagEffectLabel(tp,11561051,0)
		end
	end
end
function c11561051.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11561051.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if c:IsFaceup() and c:IsRelateToEffect(e) and ct>0 then
		c:AddCounter(0x1,ct)
	end
end