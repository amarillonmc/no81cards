--龙辉巧的赠礼
local m=11612623
local cm=_G["c"..m]
function c11612623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
end
function cm.cfilter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter2(c)
	return c:IsSetCard(0x154) and c:IsLevel(12)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter1,1,nil,tp) end
	local g=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_MZONE,0,nil) 
	if g:IsExists(cm.cfilter2,1,nil) then
		local sg1=g:FilterSelect(tp,cm.cfilter2,1,1,nil)
		g:RemoveCard(sg1:GetFirst())
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Release(sg1,REASON_COST)
	end
end
--
function cm.cfilter2(c)
	return c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	local ct=Duel.GetFieldGroupCount(0,tp,LOCATION_EXTRA)
	if ct<2 then   
		op=1
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(1-tp,aux.Stringid(m,2),aux.Stringid(m,1))
	end
	if op==0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetTarget(cm.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		ct=math.floor(ct/2)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if g2:GetCount()<=1 then return end
		local sg=g2:Select(1-tp,ct,ct,nil)
		if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
			local c=e:GetHandler()
			local og2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			local tc=og2:GetFirst()
			while tc do
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				tc=og2:GetNext()
			end
			og2:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og2)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp) 
		end
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return  c:IsSummonableCard()
end