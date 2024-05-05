--猩红涌潮
local m=30005312
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1 
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_TOHAND)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_SZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.zf(c,tp) 
	return not c:IsForbidden() and c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:CheckUniqueOnField(tp) 
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(cm.zf,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,ec,tp)
	if chk==0 then return ec:IsAbleToHand() and zt>-1 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.zf),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,ec,tp)
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 or c:GetLocation()~=LOCATION_HAND or #g==0 then return end
	Duel.AdjustAll()
	local zt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if zt<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local rk=0
	if tc:IsLocation(LOCATION_HAND) then rk=1 end
	if not tc or tc==nil then return false end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if tc:IsFacedown() or tc:GetLocation()~=LOCATION_SZONE then return false end
	if rk==0 then
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
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
--Effect 2
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and not c:IsLocation(LOCATION_HAND)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return ec:IsAbleToHand()  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 or c:GetLocation()~=LOCATION_HAND then return end
	Duel.AdjustAll()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,m)
	if #g>0 and Duel.IsPlayerCanDraw(tp,1) then 
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT) 
	end
end  