local m=53716001
local cm=_G["c"..m]
cm.name="断片折光 幻想匿国"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e1)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.actarget)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e1)
	e4:SetOperation(cm.adjustop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.fselect(g,res)
	return (res and #g~=2 and (g:IsExists(Card.IsSetCard,1,nil,0x553b) or #g==3)) or (not res and #g==3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20004==0x20004 and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local res=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
	if chk==0 then return cost:CheckSubGroup(cm.fselect,1,3,res) and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=cost:SelectSubGroup(tp,cm.fselect,false,1,3,res)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.disable)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTarget(cm.attack)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_SZONE)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e7:SetCondition(cm.spcon)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	c:RegisterEffect(e7)
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
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
	local te=e:GetLabelObject()
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
	e:SetLabelObject(te2)
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
	--[[Waiting for further repair
	for _,te3 in pairs(re3) do
		if not te3:GetLabelObject() then
			local cost=te3:GetCost()
			if cost and not cost(te3,te,tp) then
				local tg=te3:GetTarget()
				if not tg or tg(te3,e,tp) then
					table.insert(t1,te3)
					table.insert(t2,5)
				end
			end
		end
	end--]]
	local dc=Duel.CreateToken(tp,m+50)
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
	--[[Waiting for further repair
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
	end--]]
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
					local rc=Duel.CreateToken(tp,m+50)
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
function cm.disable(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.attack(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:GetType()&0x20004==0x20004 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,2500,2500,4,RACE_PSYCHO,ATTRIBUTE_WIND)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonCount(tp,1) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,2500,2500,4,RACE_PSYCHO,ATTRIBUTE_WIND) then return end
	tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(RACE_PSYCHO)
	e1:SetReset(RESET_EVENT+0x47c0000)
	tc:RegisterEffect(e1,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_WIND)
	tc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(2500)
	tc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(2500)
	tc:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(4)
	tc:RegisterEffect(e6,true)
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
end
