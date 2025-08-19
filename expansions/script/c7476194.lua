--方程式运动员 沙地耐力骑手
local s,id,o=GetID()
SNNM=SNNM or {}
local cm=SNNM
function s.initial_effect(c)
	local e1,e1_1,e2,e3=cm.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(7476193)
	e5:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.eftg)
	c:RegisterEffect(e5)
	--atk up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(s.atkval)
	c:RegisterEffect(e0)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--lv up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(s.lvcon)
	e4:SetOperation(s.lvop)
	c:RegisterEffect(e4)
	--activate from hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x107))
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetCondition(s.actcon)
	e5:SetValue(id)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	--
	cm.ActivatedAsSpellorTrapCheck(c)
end
function s.eftg(e,c)
	--if c:IsType(TYPE_MONSTER) then Debug.Message("01") end
	--if c:IsSetCard(0x107) then Debug.Message("02") end
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x107) then return false end
	local lv=e:GetHandler():GetLevel()
	if c:GetLevel()>0 then
		return c:GetOriginalLevel()<lv
	else return false end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.atkval(e,c)
	return c:GetLevel()*300
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x107)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.actcon(e)
	return e:GetHandler():IsLevelAbove(7)
end

--
function s.filter(c)
	return c:IsSetCard(0x107) and not c:IsCode(id) and c:IsType(TYPE_MONSTER)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check_second then
		local c=e:GetHandler()
		--
		s.globle_check_second=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(tc,0x20004,LOCATION_HAND)
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsHasEffect(7476193)
			end)
			e1:SetTarget(s.sptg)
			e1:SetOperation(s.spop)
		end
	end
	e:Reset()
end

--Copy from ADcalcium
--1
function cm.ActivatedAsSpellorTrap(c,otyp,loc,setava,owne)
	local e1=nil
	if owne then e1=owne else
		e1=Effect.CreateEffect(c)
		if otyp&(TYPE_TRAP+TYPE_QUICKPLAY)~=0 then
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		else e1:SetType(EFFECT_TYPE_IGNITION) end
		e1:SetRange(loc)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		c:RegisterEffect(e1)
	end
	local e1_1=Effect.CreateEffect(c)
	local e2=Effect.CreateEffect(c)
	local e3=Effect.CreateEffect(c)
	if not setava then
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(7476194)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(loc)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		c:RegisterEffect(e2)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetRange(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		c:RegisterEffect(e3)
	else
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(7476194)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		Duel.RegisterEffect(e2,0)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetLabel(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		Duel.RegisterEffect(e3,0)
		--cm.Global_in_Initial_Reset(c,{e2,e3})
	end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(7476198)
	e2_1:SetRange(loc|LOCATION_ONFIELD)
	e2_1:SetLabel(otyp)
	e2_1:SetLabelObject(e2)
	c:RegisterEffect(e2_1)
	if owne then return e1_1,e2,e3,e2_1 else return e1,e1_1,e2,e3 end
end
function cm.AASTadjustop(otyp,ext)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local adjt={}
	if ext then adjt=ext else adjt={e:GetLabelObject()} end
	if #adjt==0 then e:Reset() return end
	for _,te in pairs(adjt) do
	--local te=e:GetLabelObject()
	--if not te then Debug.Message(e:GetLabel()) return else Debug.Message(555) return end
	--if aux.GetValueType(te)~="Effect" then Debug.Message(aux.GetValueType(te)) return end
	--Debug.Message(#te)
	--Debug.Message(te:GetOwner():GetCode())
	
	local c=te:GetHandler()
	if not c:IsStatus(STATUS_CHAINING) and c:IsStatus(STATUS_EFFECT_ENABLED) then
		local xe={c:IsHasEffect(7476195)}
		for _,v in pairs(xe) do v:Reset() end
	end
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	xe1:Reset()
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
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
		for _,v2 in pairs(t1) do
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
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,false,te))
				end
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,true,te))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,true,te))
				end
			end
		end
	end
	xe1:Reset()
	end
	end
end
function cm.AASTbchval(_val,te)
	return function(e,re,...)
				if re==te then return false end
				return _val(e,re,...)
			end
end
function cm.AASTchval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.AASTchtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.AASTactarget(e,te,tp)
	if e:GetRange()==0 then
		local ce=e:GetLabelObject()
		return te:GetHandler()==e:GetOwner() and ce and te==ce and ce:GetHandler():IsLocation(e:GetLabel())
	else return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject() end
end
function cm.AASTcostchk(otyp)
	return  function(e,te,tp)
--Debug.Message(9999)
				if e:GetRange()==0 then
					local ce=e:GetLabelObject()
					if ce then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or ce:GetHandler():IsLocation(LOCATION_SZONE) or otyp&0x80000~=0 else e:Reset() return true end
				else return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():IsLocation(LOCATION_SZONE) or otyp&0x80000~=0 end
	end
end
function cm.AASTcostop(otyp)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
--Debug.Message(9999)
--Debug.Message(aux.GetValueType(te))
	local c=te:GetHandler()
	local xe1=cm.AASTregi(c,te)
	if otyp&0x80000~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		if c:IsLocation(LOCATION_SZONE) then
			Duel.MoveSequence(c,5)
			if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
		else
			c:SetCardData(4,0x80002)
			Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
			c:SetCardData(4,0x21)
		end
		if c:IsPreviousLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if c:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(otyp)
	c:RegisterEffect(e0,true)
	if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP)
		c:SetStatus(STATUS_EFFECT_ENABLED,false)
	elseif not c:IsLocation(LOCATION_SZONE) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	if c:IsPreviousLocation(LOCATION_HAND) then c:SetStatus(STATUS_ACT_FROM_HAND,true) end
	xe1:SetLabel(c:GetSequence()+1,otyp)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:CreateEffectRelation(te)
	local te2=te:Clone()
	c:RegisterEffect(te2,true)
	e:SetLabelObject(te2)
	local le1={c:IsHasEffect(7476198)}
	for _,v in pairs(le1) do v:SetLabelObject(te2) end
	local le2={c:IsHasEffect(7476198)}
	for _,v in pairs(le2) do v:GetLabelObject():SetLabelObject(te2) end
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.AASTrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	if not c:IsType(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
	end
end
function cm.AASTrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	re:Reset()
	--[[local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(re)
	e1:SetOperation(cm.AASTreset)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:Reset()
end
function cm.AASTreset(e,tp,eg,ep,ev,re,r,rp)
	local xe={e:GetOwner():IsHasEffect(7476195)}
	for _,v in pairs(xe) do if v:GetLabelObject()==e:GetLabelObject() then v:Reset() end end
	e:Reset()]]
end
function cm.AASTregi(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(7476195)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.MultipleGroupCheck(c)
	if not FA_Copy_From_ADguy_Multiple_Group_Check then
		FA_Copy_From_ADguy_Multiple_Group_Check=true
		Duel.RegisterFlagEffect(0,7476196,0,0,0,0)
		local ADIMI_IsExistingMatchingCard=Duel.IsExistingMatchingCard
		local ADIMI_SelectMatchingCard=Duel.SelectMatchingCard
		local ADIMI_GetMatchingGroup=Duel.GetMatchingGroup
		Duel.IsExistingMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		Duel.SelectMatchingCard=function(sp,f,p,s,o,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,s,o,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectMatchingCard(sp,f,p,s,o,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		Duel.GetMatchingGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_GetMatchingGroupCount=Duel.GetMatchingGroupCount
		Duel.GetMatchingGroupCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_GetFirstMatchingCard=Duel.GetFirstMatchingCard
		Duel.GetFirstMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_IsExists=Group.IsExists
		Group.IsExists=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExists(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExists(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_Filter=Group.Filter
		Group.Filter=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Filter(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Filter(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_FilterCount=Group.FilterCount
		Group.FilterCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_Remove=Group.Remove
		Group.Remove=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Remove(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Remove(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_SearchCard=Group.SearchCard
		Group.SearchCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_FilterSelect=Group.FilterSelect
		Group.FilterSelect=function(g,p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_Filter(g,f,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_FilterSelect(g,p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_CheckSubGroup=Group.CheckSubGroup
		Group.CheckSubGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_SelectSubGroup=Group.SelectSubGroup
		Group.SelectSubGroup=function(g,p,f,bool,min,max,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			f(g,...)
			--ADIMI_CheckSubGroup(g,f,min,max,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectSubGroup(g,p,f,bool,min,max,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_IsExistingTarget=Duel.IsExistingTarget
		Duel.IsExistingTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local b=ADIMI_IsExistingTarget(...)
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_SelectTarget=Duel.SelectTarget
		Duel.SelectTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local b=ADIMI_SelectTarget(...)
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_DiscardHand=Duel.DiscardHand
		Duel.DiscardHand=function(p,f,min,max,reason,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_HAND,LOCATION_HAND,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_DiscardHand(p,f,min,max,reason,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_SelectReleaseGroup=Duel.SelectReleaseGroup
		Duel.SelectReleaseGroup=function(p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroup(p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
		local ADIMI_SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		Duel.SelectReleaseGroupEx=function(p,f,min,max,r,bool,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,7476196)
			Duel.SetFlagEffectLabel(0,7476196,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			if bool then ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,ex,...) else ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...) end
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroupEx(p,f,min,max,r,bool,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,7476196,lab)
			return b
		end
	end
end
--2
function cm.SetAsSpellorTrapCheck(c,type)
	local mt=getmetatable(c)
	mt.SSetableMonster=true
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(type)
	c:RegisterEffect(e0)
	if not FA_Copy_From_ADguy_SetAsSpellorTrap_Check then
		FA_Copy_From_ADguy_SetAsSpellorTrap_Check=true
		local ADIMI_IsSSetable=Card.IsSSetable
		Card.IsSSetable=function(sc,bool)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local b=true
			if sc.SSetableMonster and (ly>0 or Duel.GetFlagEffectLabel(0,7476196)==0) then
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			else b=ADIMI_IsSSetable(sc,bool) end
			return b
		end
	end
end
function cm.ActivatedAsSpellorTrapCheck(c)
	if not FA_Copy_From_ADguy_ActivatedAsSpellorTrap_Check then
		FA_Copy_From_ADguy_ActivatedAsSpellorTrap_Check=true
		cm.MultipleGroupCheck(c)
		local ADIMI_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res=true
			if ac:GetFlagEffect(7476197)>0 then
				res=false
				ac:ResetFlagEffect(7476197)
			end
			local le={ADIMI_GetActivateEffect(ac)}
			local xe={ac:IsHasEffect(7476194)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,7476196)==0) then
				if #le>0 then
					if res and ae:GetLabelObject() then
						for k,v in pairs(le) do
							if v==ae:GetLabelObject() then
								table.insert(le,1,ae)
								table.remove(le,k+1)
								break
							end
						end
					else le={ae} end
				else le={ae} end
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			if not ae and Dimpthox_Imitation then
				for _,v in pairs(Dimpthox_Imitation) do if v:GetOwner()==ac then table.insert(le,v) end end
			end
			return table.unpack(le)
		end
		local ADIMI_CheckActivateEffect=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local le={ADIMI_CheckActivateEffect(ac,...)}
			local xe={ac:IsHasEffect(7476194)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,7476196)==0) then
				le={ae}
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			return table.unpack(le)
		end
		local ADIMI_IsActivatable=Effect.IsActivatable
		Effect.IsActivatable=function(re,...)
			if re then return ADIMI_IsActivatable(re,...) else return false end
		end
		--[[local ADIMI_IsType=Card.IsType
		Card.IsType=function(rc,type)
			local res=ADIMI_IsType(rc,type)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(7476194)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,7476196)==0 and not rc:IsLocation(LOCATION_MZONE)
			if res1 then Debug.Message("03") end
			if res2 then Debug.Message("04") end
			if ae and (res1 or res2) then res=(type&typ~=0) end
			return res
		end
		local ADIMI_CGetType=Card.GetType
		Card.GetType=function(rc)
			local res=ADIMI_CGetType(rc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(7476194)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,7476196)==0 and not rc:IsLocation(LOCATION_MZONE)
			if ae and (res1 or res2) then res=typ end
			return res
		end]]
		local ADIMI_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(rc,...)
			local xe={rc:IsHasEffect(7476195)}
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if v:GetLabelObject() and aux.GetValueType(v:GetLabelObject())=="Effect" and rc==v:GetLabelObject():GetHandler() then b=true seq,typ=v:GetLabel() end end
			if b and typ and typ~=0 and rc:IsHasEffect(7476194) then
				local e1=Effect.CreateEffect(rc)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetReset(RESET_EVENT+0xfd0000)
				e1:SetValue(typ)
				rc:RegisterEffect(e1,true)
			end
			return ADIMI_MoveToField(rc,...)
		end
		local ADIMI_CreateEffect=Effect.CreateEffect
		function Effect.CreateEffect(rc,...)
			local re=ADIMI_CreateEffect(rc,...)
			ADIMI_EHandler=ADIMI_EHandler or {}
			if re and rc then ADIMI_EHandler[re]=rc end
			return re
		end
		local ADIMI_CRegisterEffect=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			local res=ADIMI_CRegisterEffect(rc,re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if re and res then ADIMI_RegisteredEffects[re]=true end
			return res
		end
		local ADIMI_DRegisterEffect=Duel.RegisterEffect
		Duel.RegisterEffect=function(re,...)
			local res=ADIMI_DRegisterEffect(re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if re and res then ADIMI_RegisteredEffects[re]=true end
			return res
		end
		local ADIMI_IsHasType=Effect.IsHasType
		local ADIMI_GetHandler=Effect.GetHandler
		function Effect.GetHandler(re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if ADIMI_IsHasType(re,EFFECT_TYPE_XMATERIAL) and not ADIMI_RegisteredEffects[re] then return ADIMI_EHandler[re] end
			local rc=ADIMI_GetHandler(re,...)
			if not rc then return ADIMI_EHandler[re] end
			return rc
		end
		Effect.IsHasType=function(re,type)
			local res=ADIMI_IsHasType(re,type)
			local rc=ADIMI_GetHandler(re)
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&EFFECT_TYPE_ACTIVATE~=0 then return true else return false end
			else return res end
		end
		local ADIMI_EGetType=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return ADIMI_EGetType(re) end
		end
		local ADIMI_IsActiveType=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=ADIMI_IsActiveType(re,type)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then
				if type&typ~=0 then return true else return false end
			else return res end
		end
		local ADIMI_GetActiveType=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then return typ else return ADIMI_GetActiveType(re) end
		end
		--[[ADIMI_GetActivateLocation=Effect.GetActivateLocation
		Effect.GetActivateLocation=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local ls=0
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>5 then return LOCATION_FZONE elseif ls>0 then return LOCATION_SZONE else return ADIMI_GetActivateLocation(re) end
		end]]--
		local ADIMI_GetActivateSequence=Effect.GetActivateSequence
		Effect.GetActivateSequence=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(7476195)} end
			local ls=0
			local seq=ADIMI_GetActivateSequence(re)
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>0 then return ls-1 else return seq end
		end
		local ADIMI_GetChainInfo=Duel.GetChainInfo
		Duel.GetChainInfo=function(chainc,...)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local b=false
			local ls,typ=0
			if re and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				local xe={}
				if rc then xe={rc:IsHasEffect(7476195)} end
				for _,v in pairs(xe) do
					if re==v:GetLabelObject() then
						b=true
						ls,typ=v:GetLabel()
						break
					end
				end
			end
			local t={ADIMI_GetChainInfo(chainc,...)}
			if b then
				for k,info in ipairs({...}) do
					if info==CHAININFO_TYPE then t[k]=typ end
					if info==CHAININFO_EXTTYPE then t[k]=typ end
					if info==CHAININFO_TRIGGERING_LOCATION then
						if ls>5 then t[k]=LOCATION_FZONE else t[k]=LOCATION_SZONE end
					end
					if info==CHAININFO_TRIGGERING_SEQUENCE and ls>0 then t[k]=ls-1 end
					if info==CHAININFO_TRIGGERING_POSITION then t[k]=POS_FACEUP end
				end
			end
			return table.unpack(t)
		end
		local ADIMI_NegateActivation=Duel.NegateActivation
		Duel.NegateActivation=function(chainc)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local xe={}
			if re and re:GetHandler() then xe={re:GetHandler():IsHasEffect(7476195)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			local res=ADIMI_NegateActivation(chainc)
			if res and b then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
		local ADIMI_ChangeChainOperation=Duel.ChangeChainOperation
		Duel.ChangeChainOperation=function(chainc,...)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local xe={}
			if re and re:GetHandler() then xe={re:GetHandler():IsHasEffect(7476195)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then re:GetHandler():CancelToGrave(false) end
			return ADIMI_ChangeChainOperation(chainc,...)
		end
		local ADIMI_IsCanBeEffectTarget=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if c:IsHasEffect(7476194) and cm["Card_Prophecy_Certain_ACST_"..ly] then b=false else b=ADIMI_IsCanBeEffectTarget(sc,...) end
			return b
		end
	end
end
