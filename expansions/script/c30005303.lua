--黯紫魔装 ⅩⅦ
local m=30005303
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.tcon)
	e3:SetCost(cm.tcost)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_RELEASE)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m+m)
	e51:SetCondition(cm.con)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)
end
--Effect 1
function cm.thcf(c,tp)
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b3=c:GetReasonPlayer()==1-tp
	return b1 and b2 and b3 
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp)
end 
function cm.stf(c,e,tp)
	if c:IsLocation(LOCATION_DECK) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else 
		return c:IsSSetable() 
	end
end
function cm.ctf(c) 
	return c:IsType(TYPE_TRAP) and c:IsDiscardable() 
end 
function cm.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(cm.ctf,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.ctf,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local tg=eg:Filter(cm.thcf,nil,tp,rp):Filter(cm.stf,nil,e,tp)
	if chk==0 then return #tg>0 end
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local tg=eg:Filter(cm.thcf,nil,tp,rp):Filter(cm.stf,nil,e,tp)
	if #tg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tag=tg:Select(tp,1,1,nil)
	if #tag==0 then return false end
	local tc=tag:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		Duel.SSet(tp,tc,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
--Effect 2
function cm.rsf(c,tp)
	if not c:IsType(TYPE_TRAP) then return false end
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	local tge=nil
	local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,c)
	if re then
		val=re:GetValue()
		tge=re:GetTarget()
	end
	if c:IsLocation(LOCATION_HAND) then
		return (val==nil and (tae==nil or tae(re,c))) and #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else
		return c:IsReleasableByEffect() and #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
	end
end
function cm.ff(c,tc)
	if c:IsCode(tc:GetCode()) then return false end
	local b1=c:IsType(TYPE_TRAP) 
	local b2=c:GetType()==TYPE_TRAP 
	return c:IsFaceupEx() and b1 and c:IsSSetable(true) 
end
function cm.con(e)   
	return Duel.GetCurrentPhase()==PHASE_END 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,tp)
	if chk==0 then return #g>0  end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,tp)
	if  #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	if #rg==0 or Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local gt=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.ff),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,rg:GetFirst()):GetFirst()
	if not gt or gt==nil then return false end
	Duel.SSet(tp,gt)
end