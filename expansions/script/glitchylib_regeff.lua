EFFECT_NO_RECOVER = 33720228				--Affected player cannot gain LP by card effects

EVENT_CHAIN_CREATED 		= EVENT_CUSTOM+33720361 --Event raised at the very start of the Chain Link creation, before the cost is paid (if the effect has no cost, the event is raised before the activation procedures, i.e. targeting)
EVENT_EFFECTS_DISABLED		= EVENT_CUSTOM+33720327	--Event raised when the effects (mind the "s") of a card are negated (by Infinite Impermanence, Hot Red Dragon Archfiend Abyss, etc...)

aux.EnabledRegisteredEffectMods={}

--Extra Deck Procedures Info
EXTRA_DECK_INFO_MODS			= 33701360
EXTRA_DECK_PROC_SYNCHRO			= 1
EXTRA_DECK_PROC_SYNCHRO_MIX 	= 2
EXTRA_DECK_PROC_XYZ				= 3
EXTRA_DECK_PROC_XYZ_LEVEL_FREE	= 4
EXTRA_DECK_PROC_LINK			= 5

----Synchro
local _AddSynchroProc, _AddSynchroMixProc = Auxiliary.AddSynchroProcedure, Auxiliary.AddSynchroMixProcedure

function Auxiliary.AddSynchroProcedure(c,f1,f2,minc,maxc)
	if aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS] then
		if maxc==nil then maxc=99 end
		local s=getmetatable(c)
		s.ExtraDeckSummonProcTable={EXTRA_DECK_PROC_SYNCHRO,f1,f2,minc,maxc}
	end
	return _AddSynchroProc(c,f1,f2,minc,maxc)
end
function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	if aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS] then
		local s=getmetatable(c)
		s.ExtraDeckSummonProcTable={EXTRA_DECK_PROC_SYNCHRO_MIX,f1,f2,f3,f4,minc,maxc,gc}
	end
	return _AddSynchroMixProc(c,f1,f2,f3,f4,minc,maxc,gc)
end

----Xyz
local _AddXyzProc, _AddXyzProcLevelFree = Auxiliary.AddXyzProcedure, Auxiliary.AddXyzProcedureLevelFree

function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
	if aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS] then
		local s=getmetatable(c)
		if not maxct then maxct=ct end
		s.ExtraDeckSummonProcTable={EXTRA_DECK_PROC_XYZ,f,lv,ct,alterf,alterdesc,maxct,alterop}
	end
	return _AddXyzProc(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
end
function Auxiliary.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,alterdesc,alterop)
	if aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS] then
		local s=getmetatable(c)
		s.ExtraDeckSummonProcTable={EXTRA_DECK_PROC_XYZ_LEVEL_FREE,f,gf,minc,maxc,alterf,alterdesc,alterop}
	end
	return _AddXyzProcLevelFree(c,f,gf,minc,maxc,alterf,alterdesc,alterop)
end

----Link
local _AddLinkProc = Auxiliary.AddLinkProcedure

function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	if aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS] then
		if max==nil then max=c:GetLink() end
		local s=getmetatable(c)
		s.ExtraDeckSummonProcTable={EXTRA_DECK_PROC_LINK,f,min,max,gf}
	end
	return _AddLinkProc(c,f,min,max,gf)
end

--EFFECT TABLES

function Auxiliary.CheckAlreadyRegisteredEffects()
	if aux.CheckAlreadyRegisteredEffectsFlag then return end
	aux.CheckAlreadyRegisteredEffectsFlag=true
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCode(EVENT_PREDRAW)
	e1:OPT()
	e1:SetOperation(function(e)
		local g=Duel.Group(function(c) return not c:IsOriginalType(TYPE_NORMAL) end,0,LOCATION_ALL,LOCATION_ALL,nil)
		for tc in aux.Next(g) do
			if not global_card_effect_table[tc] then
				local code=tc:GetOriginalCode()
				tc:ReplaceEffect(CARD_CYBER_HARPIE_LADY,0,0)
				tc:SetStatus(STATUS_EFFECT_REPLACED,false)
				Duel.SetMetatable(tc, _G["c"..code])
				local s=getmetatable(tc)
				s.initial_effect(tc)
			end
		end
	end)
	Duel.RegisterEffect(e1,0)
end

local effect_set_target_range = Effect.SetTargetRange
Effect.SetTargetRange=function(e,self,oppo)
	local table_oppo = oppo
	if type(oppo)==nil then
		table_oppo=false
	end
	if not global_target_range_effect_table then
		global_target_range_effect_table={}
	end
	global_target_range_effect_table[e]={self,table_oppo}
	return effect_set_target_range(e,self,oppo)
end
function Effect.GLGetTargetRange(e)
	if not global_target_range_effect_table[e] then return false,false end
	local s=global_target_range_effect_table[e][1]
	local o=global_target_range_effect_table[e][2]
	return s,o
end

--Global Card Effect Table
function Card.GetEffects(c)
	local eset=global_card_effect_table[c]
	if not eset then return {} end
	-- local ct=#eset
	-- for i = 1,ct do
		-- local e=eset[i]
		-- if e and e:WasReset(c) then
			-- table.remove(global_card_effect_table[c],i)
		-- end
	-- end
	return global_card_effect_table[c]
end

if not global_card_effect_table_global_check then
	global_card_effect_table_global_check=true
	global_card_effect_table={}
	Card.register_global_card_effect_table = Card.RegisterEffect
	function Card:RegisterEffect(e,forced)
		if not global_card_effect_table[self] then global_card_effect_table[self]={} end
		table.insert(global_card_effect_table[self],e)
		
		local typ,code=e:GetType(),e:GetCode()
		
		local IsSingleOrField=typ==EFFECT_TYPE_SINGLE or typ==EFFECT_TYPE_FIELD
		local IsInherentSummonProc=code==EFFECT_SPSUMMON_PROC or code==EFFECT_SPSUMMON_PROC_G
		local IsHasExceptionType=typ==EFFECT_TYPE_XMATERIAL or typ==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or typ&EFFECT_TYPE_GRANT~=0
		
		local selfp,oppo=e:GLGetTargetRange()
		local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
		
		--Damage Replacement Effects (necessary for cards like Sepialife - Passive On Pink)
		if code==EFFECT_REVERSE_DAMAGE then
			local newcon =	function(e)
								local tp=e:GetHandlerPlayer()
								return (not condition or condition(e)) and not aux.IsChangedDamage and not aux.IsReplacedDamage
							end
			e:SetCondition(newcon)
			
			--Fix interaction between EFFECT_NO_RECOVER and damage-recovery swap effects (such as Muscle Medic)
			if aux.EnabledRegisteredEffectMods[EFFECT_NO_RECOVER] then
				local newval =	function(e,re,r,rp,rc)
									local res0=val
									if type(val)=="function" then
										res0=val(e,re,r,rp,rc)
									end
									if aux.IsDamageFunctionCalled then
										return res0
									end
									
									local tp=e:GetHandlerPlayer()
									local dam0,dam1=Duel.GetBattleDamage(0),Duel.GetBattleDamage(1)
									
									local p=dam0>0 and 0 or dam1>0 and 1 or nil
									if not p then return res0 end
									
									local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_NO_RECOVER)}
									if #eset==0 then
										return res0
									else
										if (selfp==0 and p==tp) or (oppo==0 and p==1-tp) then return res0 end
										for _,ce in ipairs(eset) do
											local res=ce:Evaluate(p,0,r)
											if res then
												return false
											end
										end
										return res0
									end
								end
				
				e:SetValue(newval)
			end
			
		elseif code==EFFECT_REFLECT_DAMAGE then
			local newcon =	function(...)
								return (not condition or condition(...)) and not aux.IsChangedDamage and not aux.IsReplacedDamage
							end
			e:SetCondition(newcon)
			
		elseif code==EFFECT_CHANGE_DAMAGE then
			local newcon =	function(...)
								return (not condition or condition(...)) and not aux.IsReplacedDamage
							end
			e:SetCondition(newcon)
		
		--Implementation for functions that make sure a card goes to a certain location after leaving its current one
		elseif code==EFFECT_CANNOT_USE_AS_COST or code==EFFECT_CANNOT_TO_GRAVE_AS_COST then
			local newcon =	function(...)
								return (not condition or condition(...)) and not aux.IgnoreCostRestrictions
							end
			e:SetCondition(newcon)
		end
		
		--Define self_reference_effect
		if condition and not IsHasExceptionType then	
			local newcon =	function(...)
								local x={...}
								local previous_sre=self_reference_effect
								self_reference_effect=x[1]
								local x={...}
								if type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								local res=condition(table.unpack(x))
								self_reference_effect=previous_sre
								return res
							end
			e:SetCondition(newcon)
		end
		if cost and not IsHasExceptionType then
			local newcost =	function(...)
								local x={...}
								local previous_sre=self_reference_effect
								self_reference_effect=x[1]
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								if #x>=9 and x[9]~=0 then
									Duel.RaiseEvent(x[1]:GetHandler(),EVENT_CHAIN_CREATED,x[1],0,x[2],x[2],Duel.GetCurrentChain())
								end
								local res=cost(table.unpack(x))
								self_reference_effect=previous_sre
								return res
							end
			e:SetCost(newcost)
		end
		if tg and not IsHasExceptionType then
			local newtg =	function(...)
								local x={...}
								local previous_sre=self_reference_effect
								self_reference_effect=x[1]
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								if #x>=9 and x[9]~=0 and (#x<10 or not x[10]) and (not x[1]:GetCost() or not x[1]:IsCostChecked()) then
									Duel.RaiseEvent(x[1]:GetHandler(),EVENT_CHAIN_CREATED,x[1],0,x[2],x[2],Duel.GetCurrentChain())
								end
								local res=tg(table.unpack(x))
								self_reference_effect=previous_sre
								return res
							end
			e:SetTarget(newtg)
		end
		if op and not IsHasExceptionType then
			local newop =	function(...)
								local x={...}
								local previous_sre=self_reference_effect
								self_reference_effect = x[1]
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								local res=op(table.unpack(x))
								self_reference_effect=previous_sre
								return res
							end
			e:SetOperation(newop)
		end
		if val and type(val)=="function" and not IsHasExceptionType then
			local newval =	function(...)
								local x={...}
								local previous_sre=self_reference_effect
								if aux.GetValueType(x[1])=="Effect" then
									self_reference_effect = x[1]
									self_reference_tp = self_reference_effect:GetHandlerPlayer()
								end
								local res={val(...)}
								self_reference_effect=previous_sre
								return table.unpack(res)
							end
			e:SetValue(newval)
		end
		if aux.PreventSecondRegistration then return end
		
		local res=self.register_global_card_effect_table(self,e,forced)
		
		--Raise EVENT_EFFECTS_DISABLED event
		if typ==EFFECT_TYPE_SINGLE and code==EFFECT_DISABLE then
			if aux.EnabledRegisteredEffectMods[EVENT_EFFECTS_DISABLED] then
				local handler,owner=e:GetHandler(),e:GetOwner()
				Duel.AdjustInstantly(handler)
				if handler:IsDisabled() and not handler:IsImmuneToEffect(e) then
					Duel.RaiseEvent(handler,EVENT_EFFECTS_DISABLED,e,REASON_EFFECT,e:GetOwnerPlayer(),handler:GetControler(),0)
				end
			end
		end
		
		return res
	end
end

--Global Card Effect Table (for Duel.RegisterEffect)
if not global_duel_effect_table_global_check then
	global_duel_effect_table_global_check=true
	global_duel_effect_table={}
	Duel.register_global_duel_effect_table = Duel.RegisterEffect
	Duel.RegisterEffect = function(e,tp)
							if tp~=0 and tp~=1 then return end
							if not global_duel_effect_table[tp] then global_duel_effect_table[tp]={} end
							table.insert(global_duel_effect_table[tp],e)
							
							local typ,code=e:GetType(),e:GetCode()
							
							local IsSingleOrField=typ==EFFECT_TYPE_SINGLE or typ==EFFECT_TYPE_FIELD
							local IsInherentSummonProc=code==EFFECT_SPSUMMON_PROC or code==EFFECT_SPSUMMON_PROC_G
							local IsHasExceptionType=typ==EFFECT_TYPE_XMATERIAL or typ==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or typ&EFFECT_TYPE_GRANT~=0
							
							local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
							
							--Damage Replacement Effects
							if code==EFFECT_REVERSE_DAMAGE then
								local newcon =	function(e,...)
													local tp=e:GetHandlerPlayer()
													return (not condition or condition(...)) and not aux.IsChangedDamage and not aux.IsReplacedDamage
														and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_RECOVER)
												end
								e:SetCondition(newcon)
								
							elseif code==EFFECT_REFLECT_DAMAGE then
								local newcon =	function(...)
													return (not condition or condition(...)) and not aux.IsChangedDamage and not aux.IsReplacedDamage
												end
								e:SetCondition(newcon)
								
							elseif code==EFFECT_CHANGE_DAMAGE then
								local newcon =	function(...)
													return (not condition or condition(...)) and not aux.IsReplacedDamage
												end
								e:SetCondition(newcon)
								
								
							elseif code==EFFECT_CANNOT_USE_AS_COST or code==EFFECT_CANNOT_TO_GRAVE_AS_COST then
								local newcon =	function(...)
													return (not condition or condition(...)) and not aux.IgnoreCostRestrictions
												end
								e:SetCondition(newcon)
							end
							
							--Define self_reference_effect
							if condition and not IsHasExceptionType then
								local newcon =	function(...)
													local x={...}
													local previous_sre=self_reference_effect
													self_reference_effect=x[1]
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													local res=condition(table.unpack(x))
													self_reference_effect=previous_sre
													return res
												end
								e:SetCondition(newcon)
							end
							if cost and not IsHasExceptionType then
								local newcost =	function(...)
													local x={...}
													local previous_sre=self_reference_effect
													self_reference_effect=x[1]
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													local res=cost(table.unpack(x))
													self_reference_effect=previous_sre
													return res
												end
								e:SetCost(newcost)
							end
							if tg and not IsHasExceptionType then
								local newtg =	function(...)
													local x={...}
													local previous_sre=self_reference_effect
													self_reference_effect=x[1]
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													local res=tg(table.unpack(x))
													self_reference_effect=previous_sre
													return res
												end
								e:SetTarget(newtg)
								
							end
							if op and not IsHasExceptionType then
								local newop =	function(...)
													local x={...}
													local previous_sre=self_reference_effect
													self_reference_effect=x[1]
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													local res=op(table.unpack(x))
													self_reference_effect=previous_sre
													return res
												end
								e:SetOperation(newop)
							end
							if val and type(val)=="function" and not IsHasExceptionType then
								local newval =	function(...)
													local x={...}
													local previous_sre=self_reference_effect
													if aux.GetValueType(x[1])=="Effect" then
														self_reference_effect = x[1]
														self_reference_tp = self_reference_effect:GetHandlerPlayer()
													end
													local res={val(...)}
													self_reference_effect=previous_sre
													return table.unpack(res)
												end
								e:SetValue(newval)
								
							end
							if aux.PreventSecondRegistration then return end
							return Duel.register_global_duel_effect_table(e,tp)
	end
end