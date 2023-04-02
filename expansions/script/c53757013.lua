if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local m=53757013
local cm=_G["c"..m]
cm.name="次元秽界魔导 驭者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_EXTRA)
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
	e4:SetRange(LOCATION_EXTRA)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(cm.ptg)
	e5:SetOperation(cm.pop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Card.IsOriginalCodeRule
		Card.IsOriginalCodeRule=function(tc,...)
			if tc:GetFlagEffect(m)>0 then return true end
			return cm[0](tc,...)
		end
		cm[1]=Card.GetOriginalCodeRule
		Card.GetOriginalCodeRule=function(tc)
			if tc:GetFlagEffect(m)>0 then
				return m
			else
				return cm[1](tc)
			end
		end
		cm[2]=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={cm[2](ac)}
			if ac:IsHasEffect(m) then
				local checke={ac:IsHasEffect(m)}
				local ae=checke[1]
				local ae1=ae:GetLabelObject()
				table.insert(le,1,ae1)
			end
			return table.unpack(le)
		end
	end
end
function cm.cfilter(c,tp,b1)
	return c:IsLevel(3) and c:IsRace(RACE_DRAGON) and (c:IsControler(tp) or c:IsFaceup()) and (b1 or Duel.GetMZoneCount(tp,c)>0)
end
function cm.thfilter(c)
	return c:IsCode(m-1) and c:IsAbleToHand()
end
function cm.filter(c)
	return c:GetType()&0x20002==0x20002 and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local res=false
	for tc in aux.Next(g) do if aux.IsCodeListed(c,tc:GetCode()) then res=true end end
	return res and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) and Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp,b1) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp,b1)
	Duel.Release(g,REASON_COST)
	local b3=b2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local res=opval[op]
	e:SetLabel(res)
	if res==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif res==2 then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
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
		Scl.Place2Field(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false,2^(math.log(flag,2)-8))
	end
	e:SetLabel(0)
	c:CreateEffectRelation(te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(TYPE_SPELL)
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
	local dc=Duel.CreateToken(tp,191749)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(m)
	dc:RegisterEffect(e1,true)
	dc:RegisterFlagEffect(m,0,0,0)
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
					local rc=Duel.CreateToken(tp,191749)
					local e1=Effect.CreateEffect(rc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_CODE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(m)
					rc:RegisterEffect(e1,true)
					rc:RegisterFlagEffect(m,0,0,0)
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
function cm.tffilter(c,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_FIELD~=0 and not c:IsLocation(LOCATION_FZONE) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if tc:IsLocation(LOCATION_SZONE) then Duel.MoveSequence(tc,5) else Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
end
