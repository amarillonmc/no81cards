local m=53799193
local cm=_G["c"..m]
cm.name="沙海的邪神 赛特"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.adjustop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		Duel.DiscardDeck=function(tp,ct,reason)
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			return Duel.SendtoGrave(g,reason)
		end
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 and c:GetFlagEffect(m+500)==0 then c:RegisterFlagEffect(m+500,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif c:GetOverlayCount()==0 and c:GetFlagEffect(m+500)>0 then 
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
		c:ResetFlagEffect(m+500)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c,e)
	return not e:GetHandler():IsHasCardTarget(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	e:GetHandler():SetCardTarget(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		if Duel.GetCurrentPhase()==PHASE_END then
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(m)~=0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(m)==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then Duel.Damage(tc:GetPreviousControler(),tc:GetBaseAttack(),REASON_EFFECT) end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetTarget(cm.rtg)
	e3:SetValue(function(e,c)return cm.dfilter(c,e:GetHandlerPlayer(),e:GetHandler())end)
	e3:SetOperation(cm.rop)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetTargetRange(0xff,0xff)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetOperation(cm.stop)
	c:RegisterEffect(e5)
end
function cm.dfilter(c,tp,tc)
	return not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:GetDestination()==LOCATION_GRAVE and not tc:GetOverlayGroup():IsContains(c) and (c:IsCanOverlay() or c:IsLocation(LOCATION_OVERLAY))
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.dfilter,1,nil,tp,e:GetHandler()) and e:GetHandler():IsType(TYPE_XYZ) and not eg:IsContains(e:GetHandler()) end
	local g=eg:Filter(cm.dfilter,nil,tp,e:GetHandler())
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local desg=Group.CreateGroup()
	local tgg=Group.CreateGroup()
	for tc in aux.Next(g) do if tc:GetEquipGroup():GetCount()>0 then desg:Merge(tc:GetEquipGroup()) end end
	for xc in aux.Next(g) do if xc:GetOverlayCount()>0 then tgg:Merge(xc:GetOverlayGroup()) end end
	for dc in aux.Next(desg) do
		if dc:IsCanOverlay() and not dc:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) then
			desg:RemoveCard(dc)
			g:AddCard(dc)
		end
	end
	local xyzg=Group.CreateGroup()
	for yc in aux.Next(tgg) do
		if yc:IsCanOverlay() and not yc:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) then
			tgg:RemoveCard(yc)
			xyzg:AddCard(yc)
		end
	end
	if #desg>0 then Duel.Destroy(desg,REASON_RULE) end
	if #tgg>0 then Duel.SendtoGrave(tgg,REASON_RULE) end
	if #xyzg>0 then Duel.Overlay(e:GetHandler(),xyzg) end
	Duel.Overlay(e:GetHandler(),g)
	g:Clear()
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if not e:GetHandler():IsType(TYPE_XYZ) then return end
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		local xyzc=Duel.GetFirstMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_MZONE,0,nil,53799193)
		if xyzc and e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and not e:GetHandler():IsHasEffect(EFFECT_REMAIN_FIELD) and e:GetHandler():IsOnField() and e:GetHandler():IsFaceup() and e:GetHandler():IsCanOverlay() then
			e:GetHandler():CancelToGrave()
			Duel.Overlay(xyzc,Group.FromCards(e:GetHandler()))
		end
	end
	re:SetOperation(repop)
end
