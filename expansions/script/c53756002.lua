if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local m=53756002
local cm=_G["c"..m]
cm.name="临终的暮辞 望美"
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
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetLabelObject(e1)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.actarget)
	e2:SetCost(cm.costchk)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetLabelObject(e1)
	e3:SetOperation(cm.adjustop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(m)
	e4:SetRange(LOCATION_HAND)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(1)
	e6:SetCondition(cm.spcon)
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
		cm[2]=Duel.GetDecktopGroup
		Duel.GetDecktopGroup=function(tp,ct)
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,0)
			return cm[2](tp,ct)
		end
		cm[3]=Duel.DiscardDeck
		Duel.DiscardDeck=function(tp,ct,reason)
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			return Duel.SendtoGrave(g,reason)
		end
	end
end
GM_global_to_deck_check=true
function cm.acsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res and tre:IsHasCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(0)
	end
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
		Scl.Place2Field(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false,2^(math.log(flag,2)-8))
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
function cm.repcheck(c,p,loc)
	local g=Duel.GetFieldGroup(p,loc,0)
	if #g==0 then return true end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	return c~=tc
end
function cm.repfilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_EFFECT) and cm.repcheck(c,0,LOCATION_DECK) and cm.repcheck(c,1,LOCATION_DECK) and cm.repcheck(c,0,LOCATION_EXTRA) and cm.repcheck(c,1,LOCATION_EXTRA)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return GM_global_to_deck_check and not eg:IsContains(c) and eg:IsExists(cm.repfilter,1,nil) end
	local p=Duel.GetTurnPlayer()
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,p,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,1,1,nil):GetFirst()
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
			rc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,p)
			if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e2=Effect.CreateEffect(c)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				c:RegisterEffect(e2)
				return false
			end
		end
	else
		GM_global_to_deck_check=false
		local g=eg:Filter(cm.repfilter,nil)
		local confirm=Group.__add(g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):Filter(Card.IsFacedown,nil),g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA))
		Duel.ConfirmCards(tp,confirm)
		Duel.ConfirmCards(1-tp,confirm)
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local chkg=g2:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #chkg>0 and Duel.GetFlagEffect(tp,m)==0 then Duel.ShuffleDeck(tp) end
		for tc2 in aux.Next(g2) do
			Duel.MoveSequence(tc2,0)
			tc2:RegisterFlagEffect(m+33,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
		if #g2==#g then
			for i=0,1 do
				local sog2=g2:Filter(Card.IsControler,nil,i)
				local exg2=sog2:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mag2=Group.__sub(sog2,exg2)
				if #mag2>1 then Duel.SortDecktop(tp,tp,#mag2) end
				for i=1,#mag2 do Duel.MoveSequence(Duel.GetDecktopGroup(tp,1):GetFirst(),1) end
				local temp2=Group.CreateGroup()
				for i=1,#exg2 do
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
					local mg2=exg2:Select(tp,1,1,temp2)
					Duel.MoveSequence(mg2:GetFirst(),1)
					temp2:Merge(mg2)
				end
			end
		else
			local g1=g:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_DECK+LOCATION_EXTRA)
			if #g1>0 then
				for tc1 in aux.Next(g1) do
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(LOCATION_DECK)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e3,true)
					tc1:RegisterFlagEffect(m+33,RESET_EVENT+0x13e0000,0,1)
				end
			end
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e4:SetCode(EVENT_TO_DECK)
			e4:SetCountLimit(1)
			e4:SetOperation(cm.tdop)
			Duel.RegisterEffect(e4,tp)
		end
		GM_global_to_deck_check=true
		return true
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m+100)==0 then
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT)
end
function cm.repval(e,c)
	return c:GetFlagEffect(m+33)~=0 and c:GetFlagEffectLabel(m+33)==1
end
function cm.tdfilter(c)
	return c:GetFlagEffect(m+33)~=0
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local gg1=Duel.GetMatchingGroup(cm.tdfilter,0,LOCATION_DECK,LOCATION_DECK,nil)
	local gg2=Duel.GetMatchingGroup(cm.tdfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	for p=0,1 do
		local g1=gg1:Filter(Card.IsControler,nil,p)
		local g2=gg2:Filter(Card.IsControler,nil,p)
		if #g1>0 then
			g1:ForEach(Card.ResetFlagEffect,m)
			Duel.SortDecktop(p,p,#g1)
			for i=1,#g1 do Duel.MoveSequence(Duel.GetDecktopGroup(p,1):GetFirst(),1) end
		end
		if #g2>0 then
			g2:ForEach(Card.ResetFlagEffect,m)
			local temp2=Group.CreateGroup()
			for i=1,#g2 do
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,2))
				local mg2=g2:Select(p,1,1,temp2)
				Duel.MoveSequence(mg2:GetFirst(),1)
				temp2:Merge(mg2)
			end
		end
	end
	e:Reset()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) and e:GetHandler():GetType()&0x20004==0x20004 and not e:GetHandler():IsStatus(STATUS_CHAINING)
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
