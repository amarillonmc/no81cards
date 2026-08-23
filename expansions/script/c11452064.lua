--星落渊积『缘起性空』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【卡片的发动】
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return true end
					if c:IsStatus(STATUS_EFFECT_ENABLED) and Duel.IsChainSolving() then cm.adjustop(e,tp,eg,ep,ev,re,r,rp) end
				end)
	e0:SetOperation(cm.adjustop)
	c:RegisterEffect(e0)
	-- ①：（只要这张卡在后场，）得到相邻区域的「落渊」卡的相同效果。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	-- 【系统后勤】：离场前夕清理复制的残余效果，防止内存泄漏或指针乱窜
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.clearop)
	c:RegisterEffect(e2)
	-- ②：表侧的这张卡回到卡组的场合发动。以下的自己1只「落渊」怪兽特殊召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(0xff)
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(cm.thcon)
	c:RegisterEffect(e4)
	if cm[EVENT_TO_DECK]==true then return end
	cm[EVENT_TO_DECK]=true
	if not g then g=Group.CreateGroup() end
	g:KeepAlive()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_TO_DECK)
	ge1:SetLabel(m)
	ge1:SetLabelObject(g)
	ge1:SetOperation(cm.MergedDelayEventCheck1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_TO_HAND)
	--Duel.RegisterEffect(ge2,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(Auxiliary.MergedDelayEventCheck2)
	Duel.RegisterEffect(ge2,0)
end
function cm.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg:Filter(function(c) return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_HAND) end,nil))
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
-- =========================================
-- ① 动态复制系统
-- =========================================
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm[c]=cm[c] or {}
	if c:IsDisabled() or c:GetEquipTarget() then cm.clear_effects(c) return end
	local g1=Duel.GetMatchingGroup(function(tc) return tc:GetSequence()<5 and c:GetSequence()-tc:GetSequence()==1 and tc:IsSetCard(0x5978) and tc:IsFaceup() end,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(function(tc) return tc:GetSequence()<5 and tc:GetSequence()-c:GetSequence()==1 and tc:IsSetCard(0x5978) and tc:IsFaceup() end,tp,LOCATION_SZONE,0,nil)
	local res1=(#g1==0 and cm[c][1]==nil) or (#g1>0 and cm[c][1]==g1:GetFirst():GetOriginalCode())
	local res2=(#g2==0 and cm[c][2]==nil) or (#g2>0 and cm[c][2]==g2:GetFirst():GetOriginalCode())
	if res1 and res2 then return end
	cm.clear_effects(c)
	local _CRegisterEffect=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,...)
		if e:GetRange()==LOCATION_PZONE then e:SetRange(LOCATION_SZONE) end
		if e:IsHasType(EFFECT_TYPE_QUICK_O) then e:SetType(EFFECT_TYPE_IGNITION) end
		return _CRegisterEffect(c,e,...)
	end
	if #g1>0 and cm[c][1]~=g1:GetFirst():GetOriginalCode() then
		local code=g1:GetFirst():GetOriginalCode()
		cm[c][1]=code
		cm[c][3]=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		if math.abs(m-code)<=4 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,6)) end
	end
	if #g2>0 and cm[c][2]~=g2:GetFirst():GetOriginalCode() then
		local code=g2:GetFirst():GetOriginalCode()
		cm[c][2]=code
		cm[c][4]=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		if math.abs(m-code)<=4 then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,6)) end
	end
	Card.RegisterEffect=_CRegisterEffect
end
function cm.clear_effects(c)
	if cm[c][1] then
		cm[c][1]=nil
		c:ResetEffect(cm[c][3],RESET_COPY)
		c:ResetFlagEffect(m)
		cm[c][3]=nil
	end
	if cm[c][2] then
		cm[c][2]=nil
		c:ResetEffect(cm[c][4],RESET_COPY)
		c:ResetFlagEffect(m+1)
		cm[c][4]=nil
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm[c]=cm[c] or {}
	if not e:GetHandler():IsLocation(LOCATION_SZONE) or e:GetHandler():IsFacedown() or e:GetHandler():IsDisabled() or e:GetHandler():GetEquipTarget() then
		cm.clear_effects(e:GetHandler())
	end
end
-- =========================================
-- ② 回卡组特殊召唤与离场重定向
-- =========================================
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5978) and c:GetOriginalType()&0x1>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,c)>0)) and c:IsFaceupEx()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local locs = LOCATION_HAND | LOCATION_SZONE | LOCATION_EXTRA | LOCATION_GRAVE | LOCATION_REMOVED | LOCATION_DECK
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,locs,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,locs)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local locs = LOCATION_HAND | LOCATION_SZONE | LOCATION_EXTRA | LOCATION_GRAVE | LOCATION_REMOVED | LOCATION_DECK
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,locs,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local prev_loc = tc:GetLocation()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e2,true)
			if (prev_loc & (LOCATION_EXTRA | LOCATION_GRAVE)) ~= 0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EFFECT_SEND_REPLACE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetTarget(cm.reptg)
				e1:SetValue(aux.TRUE)
				tc:RegisterEffect(e1,true)
				if tc:IsType(TYPE_PENDULUM) then
					tc:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,0,1)
					local _IsAbleToGraveAsCost=Card.IsAbleToGraveAsCost
					Card.IsAbleToGraveAsCost=function(c)
												if c:GetFlagEffect(m+2)>0 and c:GetLeaveFieldDest()==0 then return true end
												return _IsAbleToGraveAsCost(c)
											end
				end
			else
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				if (prev_loc & (LOCATION_HAND | LOCATION_SZONE)) ~= 0 then
					e1:SetValue(LOCATION_HAND)
					e1:SetDescription(aux.Stringid(m,1))
				elseif (prev_loc & (LOCATION_REMOVED | LOCATION_DECK)) ~= 0 then
					e1:SetValue(LOCATION_REMOVED)
					e1:SetDescription(aux.Stringid(m,3))
				end
				tc:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetDestination()&LOCATION_ONFIELD==0 and c:IsOnField() and e:GetLabel()==0
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	if r&REASON_EFFECT==0 or not re or not re:GetHandler() then
		e:SetLabel(1)
		Duel.SendtoGrave(c,r)
		e:SetLabel(0)
	else
		local rc=re:GetHandler()
		local e2=Effect.CreateEffect(rc)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CUSTOM+m+1)
		e2:SetOperation(function() Duel.SendtoGrave(c,r) end)
		Duel.RegisterEffect(e2,0)
		e:SetLabel(1)
		Duel.RaiseEvent(rc,EVENT_CUSTOM+m+1,e,0,0,0,0)
		e:SetLabel(0)
		e2:Reset()
	end
	e1:Reset()
	return true
end