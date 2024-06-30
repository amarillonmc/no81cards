--[[
砂之星之光辉
Sparkle of the Sandstar
Scintilla della Sabbiastella
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_SPARKLE)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--[[Each time you activate a card effect during your turn, and you did not activate the effect of a card with the same name previously during that turn,
	place 1 Sparkle Counter on this card immediately after that effect resolves]]
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2x:SetCode(EVENT_CHAINING)
	e2x:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2x:SetRange(LOCATION_SZONE)
	e2x:SetOperation(aux.chainreg)
	c:RegisterEffect(e2x)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(aux.TurnPlayerCond(0))
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--[[If you activate the effect of a card with the same name of a card whose effect was already activated previously during the same turn,
	remove all Sparkle Counters from this card immediately after that effect resolves]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--If you would take damage, you can remove any number of Sparkle Counters from this card, and if you do, decrease the damage by 800 for each Sparkle Counter removed this way
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.damcon)
	e4:SetValue(s.damval)
	c:RegisterEffect(e4)
	local e4x=Effect.CreateEffect(c)
	e4x:SetType(EFFECT_TYPE_FIELD)
	e4x:SetCode(id)
	e4x:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4x:SetRange(LOCATION_SZONE)
	e4x:SetCondition(s.damcon)
	e4x:SetTargetRange(1,0)
	c:RegisterEffect(e4x)
	--During the End Phase, if this card does not have a Sparkle Counter on it: Send this card to the GY.
	local e5=Effect.CreateEffect(c)
	e5:Desc(1)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE|PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.tgcon)
	e5:SetTarget(s.tgtg)
	e5:SetOperation(s.tgop)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActivated() then
		local code,code2=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if not Duel.PlayerHasFlagEffectLabel(rp,id,code) then
			Duel.RegisterFlagEffect(rp,id,RESET_PHASE|PHASE_END,0,1,code)
		else
			Duel.RegisterFlagEffect(rp,id+100,RESET_PHASE|PHASE_END,0,1,code)
		end
		if code2 and code2~=0 then
			if not Duel.PlayerHasFlagEffectLabel(rp,id,code2) then
				Duel.RegisterFlagEffect(rp,id,RESET_PHASE|PHASE_END,0,1,code2)
			else
				Duel.RegisterFlagEffect(rp,id+100,RESET_PHASE|PHASE_END,0,1,code2)
			end
		end
	end
end

--E2
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActivated() and rp==tp and c:GetFlagEffect(FLAG_ID_CHAINING)>0 then
		local code,code2=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if not Duel.PlayerHasFlagEffectLabel(tp,id+100,code) and (not code2 or code2==0 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,code2)) and c:IsCanAddCounter(COUNTER_SPARKLE,1) then 
			c:AddCounter(COUNTER_SPARKLE,1)
		end
	end
end

--E3
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActivated() and rp==tp and c:GetFlagEffect(FLAG_ID_CHAINING)>0 then
		local code,code2=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if Duel.PlayerHasFlagEffectLabel(tp,id+100,code) or (code2 and code2~=0 and Duel.PlayerHasFlagEffectLabel(tp,id+100,code2)) then
			local ct=c:GetCounter(COUNTER_SPARKLE)
			if ct>0 and c:IsCanRemoveCounter(tp,COUNTER_SPARKLE,ct,REASON_EFFECT) then
				Duel.Hint(HINT_CARD,tp,id)
				c:RemoveCounter(tp,COUNTER_SPARKLE,ct,REASON_EFFECT)
			end
		end
	end
end

--E4
if not s.AppliedGroup then
	s.AppliedGroup = Group.CreateGroup()
	s.AppliedGroup:KeepAlive()
end

function s.damcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id+200)==0 and c:GetCounter(COUNTER_SPARKLE)>0
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local a=c:GetCounter(COUNTER_SPARKLE)
	if val*a>0 then
		local av={}
		local n=math.ceil(val/800)
		for i=n,1,-1 do
			if c:IsCanRemoveCounter(tp,COUNTER_SPARKLE,i,REASON_EFFECT) then
				table.insert(av,i)
			end
		end
		if #av>0 then
			if r==REASON_BATTLE and not rc then
				rc=s.reason_card
			end
			c:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD,0,1)
			s.AppliedGroup:AddCard(c)
			local e00=Effect.CreateEffect(c)
			e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e00:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_UNCOPYABLE)
			e00:SetCode(EVENT_CUSTOM+id)
			e00:SetRange(LOCATION_SZONE)
			e00:SetCountLimit(1)
			e00:SetLabel(table.unpack(av))
			if rc then
				e00:SetLabelObject(rc)
			end
			e00:SetCondition(s.con)
			e00:SetOperation(s.op)
			e00:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			c:RegisterEffect(e00,true)
			local reasoncard=(aux.GetValueType(re)=="Effect") and re:GetHandler() or rc
			Duel.IgnoreActionCheck(Duel.RaiseEvent,reasoncard,EVENT_CUSTOM+id,re,r,rp,tp,val)
		end
	end
	return 0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetFlagEffect(id+200)~=0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=c:GetCounter(COUNTER_SPARKLE)
	local av={e:GetLabel()}
	Duel.HintSelection(Group.FromCards(c))
	if Duel.SelectYesNo(ep,aux.Stringid(id,2)) then
		local count=Duel.AnnounceNumber(ep,table.unpack(av))
		Duel.Hint(HINT_CARD,ep,id)
		c:RemoveCounter(ep,COUNTER_SPARKLE,count,REASON_EFFECT)
	end
	local b=c:GetCounter(COUNTER_SPARKLE)
	local rc=eg:GetFirst()
	if r==REASON_BATTLE then
		s.reason_card=rc
	end
	local e00=Effect.CreateEffect(rc)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DELAY)
	e00:SetCode(EVENT_CUSTOM+id+1)
	e00:SetCountLimit(1)
	e00:SetLabelObject(c)
	e00:SetOwnerPlayer(rp)
	e00:SetOperation(
		function(_e)
			local tab={Duel.IsPlayerAffectedByEffect(ep,id)}
			local dam=math.max(0,ev-(a-b)*800)
			if dam>0 then
				aux.IsChangedDamage=true
				Duel.Damage(ep,dam,r)
				aux.IsChangedDamage=false
				if r==REASON_BATTLE then
					Duel.RaiseSingleEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
					Duel.RaiseEvent(rc,EVENT_BATTLE_DAMAGE,nil,0,rp,ep,dam)
				end
			end
			if #tab==0 then
				for tc in aux.Next(s.AppliedGroup) do
					tc:ResetFlagEffect(id+200)
				end
				s.AppliedGroup:Clear()
			end
		end
	)
	e00:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e00,rp)
	Duel.RaiseEvent(rc,EVENT_CUSTOM+id+1,re,r,rp,ep,ev)
end
--E5
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():HasCounter(COUNTER_SPARKLE)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end