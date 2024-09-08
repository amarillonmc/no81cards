--猩红魔装 XX D
local m=30005300
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_LEAVE_GRAVE)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_HAND)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCost(cm.cost)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+m)
	e3:SetCondition(cm.tcon)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.ctf(c,tp) 
	local g=Duel.GetMatchingGroup(cm.zf,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,c,tp,c:GetCode())
	return c:IsType(TYPE_TRAP) and c:IsDiscardable() and #g>0
end 
function cm.zf(c,tp,code) 
	if c:IsCode(code) then return false end
	return not c:IsForbidden() and c:GetCode()~=code and c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:CheckUniqueOnField(tp) 
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.ctf,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return c:IsDiscardable() and #sg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dc=sg:Select(tp,1,1,nil):GetFirst()
	if dc==nil or not dc then return end
	e:SetLabel(dc:GetCode())
	local tg=Group.FromCards(c,dc)
	Duel.SendtoGrave(tg,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return zt>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(cm.zf,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp,e:GetLabel())
	if zt==0 or #g==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local rk=1
	if tc:IsLocation(LOCATION_HAND) then rk=0 end
	if not tc or tc==nil then return false end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if tc:IsFacedown() or tc:GetLocation()~=LOCATION_SZONE then return false end
	if rk==1  then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.tgcon)
		e1:SetOperation(cm.tgop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsOnField() and tc:IsFaceup() then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
--Effect 2
function cm.thcf(c,tp)
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_CONTINUOUS)~=0
	local b3=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b4=c:GetReasonPlayer()==1-tp
	return b1 and b2 and b3 and b4 
end
function cm.hf(c) 
	return c:IsAbleToHand() and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end 
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp)
end 
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local tg=eg:Filter(cm.thcf,nil,tp,rp):Filter(cm.hf,nil)
	if chk==0 then return ec:IsAbleToRemove() and #tg>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local tg=eg:Filter(cm.thcf,nil,tp,rp):Filter(cm.hf,nil)
	if not ec:IsRelateToEffect(e) or Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)==0 then return end
	if #tg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tag=tg:Select(tp,1,1,nil)
	if #tag==0 then return false end
	Duel.SendtoHand(tag,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tag)
end