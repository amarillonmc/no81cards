--超机龙兵 噩兆先锋
local m=21196500
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not cm._ then
		cm._=true
		cm_remove_limit_botton=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetRange(0xff)
		e0:SetCountLimit(1)
		e0:SetOperation(cm.op0)
		c:RegisterEffect(e0)
		cm_remove_limit = {}
		cm_resolve_table = {}
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_ADJUST)
		ce1:SetCondition(cm.limit_hack_con)
		ce1:SetOperation(cm.limit_hack_op)
		Duel.RegisterEffect(ce1,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE+0x200)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
cm.record_doesnot_contain = 
	function(table,effect)
		for _, value in pairs(table) do
			if value == effect then
				return false
			end
		end
		return true
	end
cm.check_or_add_new_limit = 
	function(add_or_not)
		local is_new_limit = false
		for tp = 0,1 do
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_REMOVE) then
				local limit_table = {Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_REMOVE)}
				for _, limit_effect in ipairs(limit_table) do
					if cm.record_doesnot_contain(cm_remove_limit,limit_effect) then
						if add_or_not then
							table.insert(cm_remove_limit,limit_effect)
							table.insert(cm_resolve_table,limit_effect)
						end
						is_new_limit = true
					end
				end
			end
		end
		local rg = Duel.GetFieldGroup(0,0xff,0xff)
		for tc in aux.Next(rg) do 
			if tc:IsHasEffect(tp,EFFECT_CANNOT_REMOVE) then
				local limit_table = {tc:IsHasEffect(EFFECT_CANNOT_REMOVE)}
				for _, limit_effect in ipairs(limit_table) do
					if cm.record_doesnot_contain(cm_remove_limit,limit_effect) then
						if add_or_not then
							table.insert(cm_remove_limit,limit_effect)
							table.insert(cm_resolve_table,limit_effect)
						end
						is_new_limit = true
					end
				end
			end
		end
		return is_new_limit
	end
cm.limit_hack_con = 
	function(effect)
		return cm.check_or_add_new_limit(false)
	end
cm.limit_hack_op = 
	function(effect)
		cm_resolve_table = {}
		if cm.check_or_add_new_limit(true) then
			for _,v in ipairs(cm_resolve_table) do
				local con =	v:GetCondition() or aux.TRUE
				local tg  = v:GetTarget()	 or aux.TRUE		
				local val = v:GetValue() 	 or aux.TRUE
				if v:IsHasType(EFFECT_TYPE_SINGLE) then
					v:SetCondition
					(
						function(ne,...)
							return cm_remove_limit_botton and con(ne,...)
						end
					)
				else
					v:SetTarget
					(
						function(ne,nc,...)
							return cm_remove_limit_botton and tg(ne,nc,...)
						end
					)
					v:SetValue
					(
						function(ne,nte,ntp,...)
							return cm_remove_limit_botton and val(ne,nte,ntp,...)
						end
					)
				end
			end
		end
	end
function cm.q(c)
	return c:GetOriginalCode()==m and not c:IsForbidden()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	for p = 0,1 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.op0_con)
		e1:SetOperation(cm.op0_op)
		Duel.RegisterEffect(e1,p)
	end
	e:Reset()
end
function cm.op0_con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetLocationCount(1-tp,4)>0 and Duel.IsExistingMatchingCard(cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,nil)
end
function cm.op0_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		local x=Duel.GetLocationCount(1-tp,4)
		local g=Duel.SelectMatchingCard(tp,cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,x,nil)
		for tc in aux.Next(g) do
			Duel.MoveToField(tc,tp,1-tp,LOCATION_MZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(1-tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1,true)
		end
	end
end
function cm.val(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.w(c)
	cm_remove_limit_botton=false
	local bool=c:IsAbleToRemoveAsCost()
	cm_remove_limit_botton=true
	return bool
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.w,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.w,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,e:GetHandler())
	cm_remove_limit_botton=false
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	cm_remove_limit_botton=true
end
function cm.e(c)
	return c:IsSetCard(0x6919) and not c:IsForbidden() and not c:IsCode(m)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(p,4)>0 and Duel.IsExistingMatchingCard(cm.e,p,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
	local tc=Duel.SelectMatchingCard(p,cm.e,p,LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.MoveToField(tc,p,p,LOCATION_MZONE,POS_FACEUP,true)
	end
end