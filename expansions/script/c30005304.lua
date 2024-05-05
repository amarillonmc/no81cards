--荧绿魔装 ⅩⅨ
local m=30005304
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_HANDES)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_HAND)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCondition(cm.con)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+m)
	e3:SetCondition(cm.tcon)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetCondition(cm.lecon)
		ge1:SetOperation(cm.leop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.zpf(c,tp)
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b3=c:GetReasonPlayer()==1-tp
	return b1 and b2 and b3 
end
function cm.lecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.zpf,1,nil,0) or eg:IsExists(cm.zpf,1,nil,1)
end 
function cm.leop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.zpf,nil,0)
	local bg=eg:Filter(cm.zpf,nil,1)
	if #ag>0 then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if #bg>0 then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
end
--Effect 1
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0
end 
function cm.th(c)
	local b1=c:IsAttack(2700)
	local b2=c:IsDefense(1000)
	local b3=c:IsRace(RACE_FIEND)
	return b1 and b2 and b3 and c:IsAbleToHand()
end
function cm.thf(c)
	local b1=c:IsLevel(6)
	local b2=c:IsRace(RACE_FIEND)
	return b1 and b2 and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
	local dg=Duel.GetMatchingGroup(cm.thf,tp,LOCATION_GRAVE,0,nil) 
	local dk=ec:IsDiscardable(REASON_EFFECT) and ec:IsLocation(LOCATION_HAND)
	if chk==0 then return dk and (#kg>0 or #dg>0) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
	local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thf),tp,LOCATION_GRAVE,0,nil) 
	if #kg==0 and #dg==0 then return false end
	local op=aux.SelectFromOptions(tp,{#kg>0,aux.Stringid(m,0)},{#dg>0,aux.Stringid(m,1)})
	local g
	local dh=false
	if op==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=kg:Select(tp,1,1,nil)
		if #g==0 then return false end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		dh=true
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=dg:Select(tp,1,1,nil) 
		if #g==0 then return false end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		dh=true
	end
	if dh==true and ec:IsRelateToEffect(e) then 
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
	end
end  
--Effect 2
function cm.thcf(c,tp,rp)
	local b1=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b2=bit.band(c:GetPreviousRaceOnField(),RACE_FIEND)~=0 
	local b3=c:GetReasonPlayer()==1-tp
	return c:IsPreviousControler(tp) and (b1 or b2) and b3 
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.suf(c,ec)
	if not c:IsRace(RACE_FIEND) or not c:IsLevel(6) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil)
	e1:Reset()
	return res
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end 
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return ec:IsAbleToHand()  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not ec:IsRelateToEffect(e) or Duel.SendtoHand(ec,nil,REASON_EFFECT)==0 or ec:GetLocation()~=LOCATION_HAND then return end
	Duel.ShuffleHand(tp)
	local kg=Duel.GetMatchingGroup(cm.suf,tp,LOCATION_HAND,0,nil,ec)
	if #kg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.suf,tp,LOCATION_HAND,0,1,1,nil,ec):GetFirst()
		if not tc or tc==nil then return false end
		local e1=Effect.CreateEffect(ec)
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(cm.ntcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end