--赎罪的标准 亚·达哈卡达埃瓦-SYS
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),10,2,nil,aux.Stringid(m,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m-1)
	e2:SetCost(cm.ovlcost)
	e2:SetTarget(cm.ovltg)
	e2:SetOperation(cm.ovlop)
	c:RegisterEffect(e2)
	--to pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,m-2)
	e3:SetCondition(cm.pencon)
	e3:SetTarget(cm.pentg)
	e3:SetOperation(cm.penop)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se) or (se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL))
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.ovlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsAbleToRemoveAsCost,nil)
	if chk==0 then return #og>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=og:Select(tp,1,1,nil):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
		c:RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EVENT_CHAIN_DISABLED)
		e3:SetOperation(cm.retop2)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if e:GetCode()==EVENT_CHAIN_SOLVED then
		local flag=c:GetFlagEffectLabel(m+1)
		c:SetFlagEffectLabel(m+1,flag+1)
	end
	if Duel.GetCurrentChain()==1 then
		local flag0=c:GetFlagEffectLabel(m+1)
		local flag=tc:GetFlagEffectLabel(m)
		local flag2=c:GetFlagEffectLabel(m)
		if flag and e:GetLabel()==flag and flag2 and e:GetLabel()==flag2 and c:IsType(TYPE_XYZ) and tc:IsCanOverlay() then
			Duel.Overlay(c,tc)
			Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,flag0,0,0,0)
		elseif flag and e:GetLabel()==flag then
			Duel.SendtoGrave(tc,REASON_RETURN+REASON_RULE)
		end
		c:ResetFlagEffect(m)
		tc:ResetFlagEffect(m)
		e:Reset()
	end
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m+1)
	c:SetFlagEffectLabel(m+1,flag-1)
end
function cm.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return #rg>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.mvop)
	Duel.RegisterEffect(e2,tp)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if #rg>0 and r>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=rg:Select(tp,1,r,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and re and c:GetReasonPlayer()==1-tp
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	local rtype=re:GetActiveType()&0x7
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetLabel(rtype)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetActiveType()&e:GetLabel()>0 and not re:GetHandler():IsCode(m)
end