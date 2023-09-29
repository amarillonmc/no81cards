local m=53756004
local cm=_G["c"..m]
cm.name="期待的暮辞 御幸"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xa530),LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.acsptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e2)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.actarget)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(m)
	e4:SetRange(LOCATION_HAND)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.negcon)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(1)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Card.IsOriginalCodeRule
		Card.IsOriginalCodeRule=function(tc,...)
			if tc:GetFlagEffect(m+66)>0 then return true end
			return cm[0](tc,...)
		end
		cm[1]=Card.GetOriginalCodeRule
		Card.GetOriginalCodeRule=function(tc)
			if tc:GetFlagEffect(m+66)>0 then
				return m
			else
				return cm[1](tc)
			end
		end
	end
end
function cm.acsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(0)
	end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject():GetLabelObject()
end
function cm.costchk(e,te_or_c,tp)
	local fdzone=0
	for i=0,4 do if Duel.CheckLocation(tp,LOCATION_SZONE,i) then fdzone=fdzone|1<<i end end
	if aux.GetValueType(te_or_c)=="Effect" and te_or_c:IsHasProperty(EFFECT_FLAG_LIMIT_ZONE) then
		local zone=te_or_c:GetValue()
		if aux.GetValueType(c)=="function" then
			zone=zone(te_or_c,tp)
		end
		fdzone=fdzone&zone
		e:SetLabel(fdzone)
	end
	return fdzone>0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject():GetLabelObject()
	local zone=e:GetLabel()
	if zone==0 then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false) else
		local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~zone&0x1f00)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false,2^(math.log(flag,2)-8))
	end
	e:SetLabel(0)
	c:CreateEffectRelation(te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x20004)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	local te2=te:Clone()
	c:RegisterEffect(te2,true)
	e:GetLabelObject():SetLabelObject(te2)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	re:Reset()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local re1={c:IsHasEffect(EFFECT_CANNOT_TRIGGER)}
	local re2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,te1 in pairs(re1) do
		table.insert(t1,te1)
		if te1:GetType()==EFFECT_TYPE_SINGLE then
			table.insert(t2,1)
		end
		if te1:GetType()==EFFECT_TYPE_EQUIP then
			table.insert(t2,2)
		end
		if te1:GetType()==EFFECT_TYPE_FIELD then
			table.insert(t2,3)
		end
	end
	for _,te2 in pairs(re2) do
		local val=te2:GetValue()
		if aux.GetValueType(val)=="number" or val(te2,te,tp) then
			table.insert(t1,te2)
			table.insert(t2,4)
		end
	end
	for _,te3 in pairs(re3) do
		if not te3:GetLabelObject() then
			local cost=te3:GetCost()
			if cost and not cost(te3,te,tp) then
				local tg=te3:GetTarget()
				if not tg or tg(te3,te,tp) then
					table.insert(t1,te3)
					table.insert(t2,5)
				end
			end
		end
	end
	local dc=Duel.CreateToken(tp,1344018)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(m)
	dc:RegisterEffect(e1,true)
	dc:RegisterFlagEffect(m+66,0,0,0)
	local de=dc:GetActivateEffect()
	local ae2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	local ae3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	local t3,t4={},{}
	for _,te2 in pairs(ae2) do
		local val=te2:GetValue()
		if aux.GetValueType(val)=="number" or val(te2,de,tp) then
			table.insert(t3,te2)
			table.insert(t4,4)
		end
	end
	for _,te3 in pairs(ae3) do
		if not te3:GetLabelObject() then
			local cost=te3:GetCost()
			if cost and not cost(te3,de,tp) then
				local tg=te3:GetTarget()
				if not tg or tg(te3,de,tp) then
					table.insert(t3,te3)
					table.insert(t4,5)
				end
			end
		end
	end
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for k,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for k,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local con=v:GetCondition()
			if not con then con=aux.TRUE end
			v:SetCondition(cm.chcon(con,false))
		end
		if ret2[k]==2 then
			local con=v:GetCondition()
			if not con then con=aux.TRUE end
			v:SetCondition(cm.chcon2(con,false))
		end
		if ret2[k]==3 then
			local tg=v:GetTarget()
			if not tg then
				v:SetTarget(cm.chtg(aux.TRUE,false))
			elseif tg(v,c)==true then
				v:SetTarget(cm.chtg(tg,false))
			end
		end
		if ret2[k]==4 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,tp) then
				v:SetValue(cm.chval(val,false))
			end
		end
		if ret2[k]==5 then
			if not v:GetLabelObject() then
				local cost=v:GetCost()
				if cost and not cost(v,te,tp) then
					local tg=v:GetTarget()
					if not tg then
						v:SetTarget(cm.chtg2(aux.TRUE,false))
					elseif tg(v,te,tp) then
						v:SetTarget(cm.chtg2(tg,false))
					end
				end
			end
		end
	end
	for k,v in pairs(ret3) do
		if ret4[k]==4 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,de,tp) then
				v:SetValue(cm.chval(val,true))
			end
		end
		if ret4[k]==5 then
			if not v:GetLabelObject() then
				local cost=v:GetCost()
				if cost and not cost(v,de,tp) then
					local tg=v:GetTarget()
					if not tg then
						v:SetTarget(cm.chtg2(aux.TRUE,true))
					elseif tg(v,de,tp) then
						v:SetTarget(cm.chtg2(tg,true))
					end
				end
			end
		end
	end
end
function cm.chcon(_con,res)
	return function(e,...)
				local x=e:GetHandler()
				if x:IsHasEffect(m) then return res end
				return _con(e,...)
			end
end
function cm.chcon2(_con,res)
	return function(e,...)
				local x=e:GetHandler():GetEquipTarget()
				if x:IsHasEffect(m) then return res end
				return _con(e,...)
			end
end
function cm.chtg(_tg,res)
	return function(e,c,...)
				if c:IsHasEffect(m) then return res end
				return _tg(e,c,...)
			end
end
function cm.chval(_val,res)
	return function(e,re,...)
				local x=nil
				if aux.GetValueType(re)=="Effect" then x=re:GetHandler() elseif aux.GetValueType(re)=="Card" then
					local rc=Duel.CreateToken(tp,1344018)
					local e1=Effect.CreateEffect(rc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_CODE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(m)
					rc:RegisterEffect(e1,true)
					rc:RegisterFlagEffect(m+66,0,0,0)
					re=rc:GetActivateEffect()
				else return res end
				if x and x:IsHasEffect(m) then return res end
				return _val(e,re,...)
			end
end
function cm.chtg2(_tg,res)
	return function(e,te,...)
				local x=te:GetHandler()
				if x:IsHasEffect(m) then return res end
				return _tg(e,te,...)
			end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) or Duel.GetCurrentPhase()==PHASE_BATTLE_STEP) and Duel.GetFlagEffect(0,m)==0
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local p=Duel.GetAttacker():GetControler()
	local apply=true
	if Duel.IsExistingMatchingCard(cm.atkfilter,p,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
		local g=Duel.SelectMatchingCard(p,cm.atkfilter,p,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			if not c:IsImmuneToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				apply=false
				local e2=Effect.CreateEffect(c)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				c:RegisterEffect(e2)
			end
		end
	end
	if apply then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_DAMAGE,0,1)
		Duel.NegateAttack()
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
