--[[
【日】ANTHEM - 轮回
【Ｏ】Anthem - Reincarnation
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
if not TYPE_DOUBLESIDED then
	Duel.LoadScript("glitchylib_doublesided.lua")
end
Duel.LoadScript("glitchylib_soundstage.lua")
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	aux.AddDoubleSidedProc(c,SIDE_OBVERSE,id+1,id)
	c:Activation()
	c:EnableCounterPermit(COUNTER_ANTHEM_REINCARNATION)
	--[[Each time you take damage, place 1 counter on this card for each 100 damage you took.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(aux.RelationTarget)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--[[If this card leaves the field, you take damage equal to the number of counters this card had on the field x 100]]
	local ct=aux.RegisterCountersBeforeLeavingField(c,COUNTER_ANTHEM_REINCARNATION)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabelObject(ct)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--[[If you would take a damage that is greater than or equal to your LP, toss 7 coins, and if all results are Heads, that damage becomes 0, and if it does,
	your LP becomes 100, and if they do, Transform this card. For every 10 counters on this card when this effect resolves, you can toss 1 less coin
	(You do not toss any coin to resolve this effect if there are 70 or more counters on this card).]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_REPLACE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.damcon)
	e3:SetValue(s.damval)
	c:RegisterEffect(e3)
end
s.toss_coin=true

--E1
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or ev<100 then return end
	if not Duel.IsChainSolving() then
		s.addcounter(e,tp,eg,ep,ev,re,r,rp)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetRange(LOCATION_FZONE)
		e1:SetLabel(ev)
		e1:SetOperation(s.addcounter)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function s.addcounter(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dam=e:GetCode()==EVENT_CHAIN_SOLVED and e:GetLabel() or ev
	local ct=dam//100
	if c:IsCanAddCounter(COUNTER_ANTHEM_REINCARNATION,ct,true) then
		c:AddCounter(COUNTER_ANTHEM_REINCARNATION,ct,true)
	end
end

--E2
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.Damage(tp,ct*100,REASON_EFFECT)
	end
end

--E3
function s.damcon(e)
	return not Duel.PlayerHasFlagEffect(tp,id)
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if val<Duel.GetLP(tp) then
		return val
	end
	
	if aux.DamageReplacementEffectAlreadyUsed[e]~=nil or (aux.IsReplacedDamage and aux.DamageReplacementEffectWasApplied) then return val end
	aux.IsReplacedDamage=true
	aux.DamageReplacementEffectAlreadyUsed[e]=true
	
	if r==REASON_BATTLE and not rc then
		rc=s.reason_card
	end
	
	local fid=c:GetFieldID()
	Duel.RegisterFlagEffect(tp,id,0,0,0,fid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	if rc then
		e1:SetLabelObject(rc)
	end
	e1:SetCondition(s.damrepcon)
	e1:SetOperation(s.damrepop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local reasoncard=(aux.GetValueType(re)=="Effect") and re:GetHandler() or rc
	Duel.IgnoreActionCheck(Duel.RaiseEvent,reasoncard,EVENT_CUSTOM+id,re,r,rp,tp,val)
	return 0
end
function s.damrepcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.PlayerHasFlagEffectLabel(tp,id,e:GetLabel())
end
function s.damrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,0,0,0)
	local res=s.damrep(e,tp,c)
	aux.DamageReplacementEffectWasApplied=res
	local rc=eg:GetFirst()
	
	if not res and r==REASON_BATTLE then
		s.reason_card=rc
		local dam=Duel.Damage(ep,ev,r)
		if dam>0 then
			Duel.RaiseSingleEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
			Duel.RaiseEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
		end
	elseif res then
		Duel.SetLP(tp,100)
		if Duel.GetLP(tp)==100 and c:HasFlagEffect(id) then
			c:ResetFlagEffect(id)
			Duel.Transform(c,SIDE_REVERSE,e,tp,REASON_EFFECT)
		end
	end
	
	Duel.ResetFlagEffect(tp,id)
	c:ResetFlagEffect(id)
end
function s.damrep(e,tp,c)
	Duel.Hint(HINT_CARD,tp,id)
	local ct=7-c:GetCounter(COUNTER_ANTHEM_REINCARNATION)//10
	if ct>0 then
		local results={Duel.TossCoin(tp,ct)}
		for _,i in ipairs(results) do
			if i==0 then
				return false
			end
		end
	end
	return true
end