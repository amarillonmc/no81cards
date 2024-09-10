EFFECT_NO_RECOVER = 33720228	--Affected player cannot gain LP by card effects

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
		
		local code=e:GetCode()
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
		if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then	
			local newcon =	function(...)
								self_reference_effect=e
								local x={...}
								if type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return condition(...)
							end
			e:SetCondition(newcon)
		end
		if cost and not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
			local newcost =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return cost(...)
							end
			e:SetCost(newcost)
		end
		if tg then
			if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			end
		end
		if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
			local newop =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return op(...)
							end
			e:SetOperation(newop)
		end
		if val then
			if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
				local newval =	function(...)
									self_reference_effect=e
									return val(...)
								end
				e:SetValue(newval)
				
			end
		end
		if aux.PreventSecondRegistration then return end
		return self.register_global_card_effect_table(self,e,forced)
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
							
							local code=e:GetCode()
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
							if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcon =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return condition(...)
												end
								e:SetCondition(newcon)
							end
							if cost and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcost =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return cost(...)
												end
								e:SetCost(newcost)
							end
							if tg then
								if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0) then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								end
							end
							if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newop =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return op(...)
												end
								e:SetOperation(newop)
							end
							if val then
								if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
									local newval =	function(...)
														self_reference_effect=e
														return val(...)
													end
									e:SetValue(newval)
								
								end
							end
							if aux.PreventSecondRegistration then return end
							return Duel.register_global_duel_effect_table(e,tp)
	end
end