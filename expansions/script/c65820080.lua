--源于黑影 既视
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	if not s.check_limit then
		s.check_limit = true
		record_limit_activate = {}
		record_limit_trigger = {}
		record_limit_spsummon = {}
		resolve_table = {}
		spsummon_limit_table = {}
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_ADJUST)
		ce1:SetCondition(s.limit_check_con)
		ce1:SetOperation(s.limit_hack_op)
		Duel.RegisterEffect(ce1,0)
		local ce2=Effect.CreateEffect(c)
		ce2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce2:SetCode(EVENT_ADJUST)
		ce2:SetCondition(s.limit_check_con2)
		ce2:SetOperation(s.limit_hack_op2)
		Duel.RegisterEffect(ce2,0)				
	end	
end
function s.record_doesnot_contain(tbl,effect)
	for _, value in pairs(tbl) do
		if value == effect then
			return false
		end
	end
	return true
end
function s.check_or_add_new_limit(add_or_not)
	local is_new_limit = false
	for tp = 0,1 do
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) then
			local limit_table = {Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
			for _, limit_effect in ipairs(limit_table) do
				if s.record_doesnot_contain(record_limit_activate,limit_effect) then
					if add_or_not then
						table.insert(record_limit_activate,limit_effect)
						table.insert(resolve_table,limit_effect)
					end
					is_new_limit = true
				end
			end
		end
	end
	local ag = Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(ag) do
		if tc:IsHasEffect(EFFECT_CANNOT_TRIGGER) then
			local limit_table = {tc:IsHasEffect(EFFECT_CANNOT_TRIGGER)}
			for _, limit_effect in ipairs(limit_table) do
				if s.record_doesnot_contain(record_limit_trigger,limit_effect) then
					if add_or_not then
						table.insert(record_limit_trigger,limit_effect)
						table.insert(resolve_table,limit_effect)
					end
					is_new_limit = true
				end
			end
		end
	end
	return is_new_limit
end
function s.limit_check_con(e)
	return s.check_or_add_new_limit(false)
end
function s.limit_hack_op(e)
	resolve_table = {}
	if s.check_or_add_new_limit(true) then
		for _, resolve_effect in ipairs(resolve_table) do
			local resolve_condition = resolve_effect:GetCondition() or aux.TRUE
			local resolve_target = resolve_effect:GetTarget() or aux.TRUE		
			local resolve_value = resolve_effect:GetValue() or aux.TRUE
			if resolve_effect:IsHasType(EFFECT_TYPE_SINGLE) then
				resolve_effect:SetCondition(
					function(ne,...)
						return not ne:GetHandler():IsCode(id) and not (ne:GetHandler():IsSetCard(0x3a32) and Duel.IsPlayerAffectedByEffect(ne:GetHandlerPlayer(),id))and resolve_condition(ne,...)
					end )
			else
				resolve_effect:SetTarget(
					function(ne,nc,...)
						return not nc:IsCode(id) and not (nc:IsSetCard(0x3a32) and Duel.IsPlayerAffectedByEffect(nc:GetControler(),id)) and resolve_target(ne,nc,...) 
					end	)
				resolve_effect:SetValue(
				function(ne,nte,ntp,...)
					if nte:GetHandler():IsCode(id) or (nte:GetHandler():IsSetCard(0x3a32) and Duel.IsPlayerAffectedByEffect(nte:GetHandlerPlayer(),id)) then
	   					return false
	  				end
   					if type(resolve_value) == "function" then
	   					return resolve_value(ne,nte,ntp,...)
					else
						return resolve_value
   					end
				end	)
			end
		end
	end
end
function s.record_doesnot_contain2(tbl,effect)
	for _, value in pairs(tbl) do
		if value == effect then
			return false
		end
	end
	return true
end
function s.check_or_add_new_limit2(add_or_not)
	local is_new_limit = false
	for tp = 0,1 do
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) then
			local limit_table = {Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
			for _, limit_effect in ipairs(limit_table) do
				if s.record_doesnot_contain2(record_limit_spsummon,limit_effect) then
					if add_or_not then
						table.insert(record_limit_spsummon,limit_effect)
						table.insert(spsummon_limit_table,limit_effect)
					end
					is_new_limit = true
				end
			end
		end
	end
	return is_new_limit
end
function s.limit_check_con2(e)
	return s.check_or_add_new_limit2(false)
end
function s.limit_hack_op2(e)
	spsummon_limit_table = {}
	if s.check_or_add_new_limit2(true) then
		for _, spsummon_effect in ipairs(spsummon_limit_table) do
			local spsummon_target = spsummon_effect:GetTarget() or aux.TRUE		
			local spsummon_value = spsummon_effect:GetValue() or aux.TRUE
				spsummon_effect:SetTarget(
					function(ne,nc,...)
						return not (nc:IsSetCard(0x3a32) and Duel.IsPlayerAffectedByEffect(nc:GetControler(),id)) and spsummon_target(ne,nc,...)
					end	)
				spsummon_effect:SetValue(
					function(ne,nte,ntp,...)
						if nte:GetHandler():IsSetCard(0x3a32) and Duel.IsPlayerAffectedByEffect(nc:GetControler(),id) then
		 					return false
	   					end
						if type(spsummon_value) == "function" then
							return spsummon_value(ne,nte,ntp,...)
						else
							return spsummon_value
						end
					end	)				
		end
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp then
	e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+0x200)	
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTarget(s.ssplimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	--Duel.RegisterEffect(e2,tp)
end
function s.ssplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3a32)
end