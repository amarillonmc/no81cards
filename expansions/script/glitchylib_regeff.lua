--EFFECT TABLES
--Global Card Effect Table
if not global_card_effect_table_global_check then
	global_card_effect_table_global_check=true
	global_card_effect_table={}
	Card.register_global_card_effect_table = Card.RegisterEffect
	function Card:RegisterEffect(e,forced)
		if not global_card_effect_table[self] then global_card_effect_table[self]={} end
		table.insert(global_card_effect_table[self],e)
		
		local code=e:GetCode()
		local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
		
		--Damage Replacement Effects (necessary for cards like Sepialife - Passive On Pink)
		if code==EFFECT_REVERSE_DAMAGE or code==EFFECT_REFLECT_DAMAGE then
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
		return self.register_global_card_effect_table(self,e,forced)
	end
end

--Global Card Effect Table (for Duel.RegisterEffect)
if not global_duel_effect_table_global_check then
	global_duel_effect_table_global_check=true
	global_duel_effect_table={}
	Duel.register_global_duel_effect_table = Duel.RegisterEffect
	Duel.RegisterEffect = function(e,tp)
							if not global_duel_effect_table[tp] then global_duel_effect_table[tp]={} end
							table.insert(global_duel_effect_table[tp],e)
							
							local code=e:GetCode()
							local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
							
							--Damage Replacement Effects
							if code==EFFECT_REVERSE_DAMAGE or code==EFFECT_REFLECT_DAMAGE then
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
							return Duel.register_global_duel_effect_table(e,tp)
	end
end