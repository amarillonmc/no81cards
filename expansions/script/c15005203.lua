local m=15005203
local cm=_G["c"..m]
cm.name="艾尔海森-正理"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,cm.lcheck)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(cm.tgcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.tgcon)
	e2:SetValue(cm.atktg)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.atkcon)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--place counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.ctcost)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
	if not TddSkandhaGlobalCheck then
		TddSkandhaGlobalCheck=true
		_SkandhaCRemoveCounter=Card.RemoveCounter
		function Card.RemoveCounter(tc,p,countertype,ct,r,re)
			if countertype==0 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),count)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),count)
				end
			end
			if countertype==0x1f37 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),ct)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),ct)
				end
			end
			return _SkandhaCRemoveCounter(tc,p,countertype,ct,r)
		end
		_SkandhaDRemoveCounter=Duel.RemoveCounter
		function Duel.RemoveCounter(p,s,o,countertype,ct,r)
			if countertype~=0x1f37 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			if s~=0 and o~=0 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			local f=function(c)
						return c:GetCounter(0x1f37)>0
					end
			local rmg=Duel.GetMatchingGroup(f,p,s,o,nil)
			local rmg0=rmg:Filter(Card.IsControler,nil,0)
			local rmg1=rmg:Filter(Card.IsControler,nil,1)
			if #rmg0~=0 then 
				Duel.RaiseEvent(rmg0,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,0,ct)
			end
			if #rmg1~=0 then 
				Duel.RaiseEvent(rmg1,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,1,ct)
			end
			return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0=eg:Filter(Card.IsControler,nil,0):GetSum(Card.GetCounter,0x1f37)
							local ct1=eg:Filter(Card.IsControler,nil,1):GetSum(Card.GetCounter,0x1f37)
							e:SetLabel(ct0,ct1)
						end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							return ct0~=0 or ct1~=0
						end)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							if ct0~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,0,ct0)
							end
							if ct1~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,1,ct1)
							end
						end)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CUSTOM+15005200)
		ge3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0
						end)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_REMOVE_COUNTER+0x1f37)
		ge4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0 and (rp==0 or rp==1)
						end)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge4,0)
	end
end
cm.counter_add_list={0x1f37}
function cm.lctfilter(c)
	return aux.IsCounterAdded(c,0x1f37)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lctfilter,1,nil)
end
function cm.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.atktg(e,c)
	return c:IsFaceup() and aux.IsCounterAdded(c,0x1f37) and c~=e:GetHandler()
end
function cm.atkcon(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and bc and bc:GetCounter(0x1f37)~=0
end
function cm.atkval(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:GetCounter(0x1f37)*300
end
function cm.filter(c)
	return c:GetCounter(0x1f37)>0
end
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.ctfilter(c)
	return c:IsCanAddCounter(0x1f37,1)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	local count=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f37)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	Duel.RemoveCounter(tp,LOCATION_MZONE,0,0x1f37,Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f37),REASON_COST)
	Duel.SetTargetParam(count)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local x=0
	while x<ct do
		local g=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1f37,1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+15005201,e,0,tp,tp,1)
		x=x+1
	end
end