--绛胧烈刃辐散跃迁
local m=11451719
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_CHAIN_END)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.costcon)
	e3:SetTarget(cm.costtg)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	if not TRADIATION_OF_CRIMSONBLAZE then
		TRADIATION_OF_CRIMSONBLAZE=true
		local _AnnounceNumber=Duel.AnnounceNumber
		function Duel.AnnounceNumber(p,...)
			if cm.Number_To_Dice then
				local tab={...}
				local d=Duel.TossDice(p,1)
				if not tab[d] then d=math.max(d%(#tab),1) end
				local res1,res2=tab[d],d
				cm.Number_To_Dice=false
				_AnnounceNumber(p,res1)
				return res1,res2
			else
				local res1,res2=_AnnounceNumber(p,...)
				return res1,res2
			end
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	e:SetCategory(0)
	if Duel.CheckEvent(EVENT_CUSTOM+m) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if e:GetLabel()==1 and c:IsRelateToEffect(e) and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local sc=sg:GetFirst()
		if Duel.Remove(sc,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and sc:IsLocation(LOCATION_REMOVED) then
			sc:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,8,aux.Stringid(11451718,8))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(sc:GetFieldID())
			e1:SetLabelObject(sc)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(11451718)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=9 then
		c:ResetFlagEffect(11451718)
		Duel.ReturnToField(c)
		e:Reset()
	else
		flag=flag+1
		c:ResetFlagEffect(11451718)
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451718,flag))
	end
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.costtg(e,te,tp)
	local code=te:GetOwner():GetOriginalCode()
	--continuously updating
	local tab={11451711,11451712,11451713,11451714,11451715,70916046,71100107}
	for _,ct in pairs(tab) do
		if ct==code and not te:IsHasType(EFFECT_TYPE_TRIGGER_O) then return true end
	end
	return false
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
		cm.Number_To_Dice=true
	end
	cm[0]=true
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end