--陷阱反击防护罩
local cm,m=GetID()
function c71500005.initial_effect(c)
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+2)
	e2:SetCost(cm.thcost)
	e2:SetOperation(cm.cdop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10045474,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.tdcon2)
	e3:SetTarget(cm.tdtg2)
	e3:SetOperation(cm.tdop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	if cm.counter==nil then
		cm.counter=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(cm.addcount)
		Duel.RegisterEffect(e3,0)
	end
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)  then
		if  re:GetHandlerPlayer()==tp then
			local rc=re:GetHandler()
			local g71500005=Group.CreateGroup()
			if e:GetLabelObject()==nil then  
			g71500005:AddCard(rc)
			else   
			g71500005:Merge(e:GetLabelObject())
			g71500005:AddCard(rc)
			end
			g71500005:KeepAlive()
			e:SetLabelObject(g71500005)
			if g71500005:GetClassCount(Card.GetCode)>=3 then Duel.RegisterFlagEffect(tp,m,0,0,0) end
		else
			local rc=re:GetHandler()
			local g71500006=Group.CreateGroup()
			if e:GetLabelObject()==nil then  
			g71500006:AddCard(rc)
			else   
			g71500006:Merge(e:GetLabelObject())
			g71500006:AddCard(rc)
			end
			g71500006:KeepAlive()
			e:SetLabelObject(g71500006)
			if g71500006:GetClassCount(Card.GetCode)>=3 then Duel.RegisterFlagEffect(1-tp,m,0,0,0) end
		end
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.cdop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LPCOST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(cm.costchange)
	Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetValue(1)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
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
	return not re:GetHandler():IsType(TYPE_TRAP)
end
function cm.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetOwnerPlayer() then return 0
	else return val end
end
function cm.costchange(e,re,rp,val)
	if re  and not re:GetHandler():IsCode(9236985,57496978) then
		return 0
	else
		return val
	end
end
function cm.fit(c)
	return not c:IsType(TYPE_TRAP)
end
function cm.handcon(e)
	return Duel.GetMatchingGroupCount(cm.fit,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)==0
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==nil then return false 
		else return  Duel.GetFlagEffect(tp,m)>0 end
end
function cm.stfilter(c)
	return c:IsSSetable() and not c:IsForbidden() and c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function cm.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsAbleToHand() end
end
function cm.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		end
	local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #tg<1 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local sg=tg:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end