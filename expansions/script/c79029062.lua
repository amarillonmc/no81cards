--啸岚寒域 耶拉冈德
local m=79029062
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.con)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--Effect 2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m+100)
	e1:SetCost(cm.spcost)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	--Effect 4 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.tg4)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	--Effect 5 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,m+101)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end
cm.named_with_KarlanTrade=true 
--Effect 1
function cm.spfilter3(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter3,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,1,REASON_EFFECT)==1 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
--Effect 2
function cm.cfilter3(c)
	return c:IsFaceup() and c.named_with_KarlanTrade and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.ctfil(c)
	return c:IsType(TYPE_MONSTER)
	and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.ctfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g) 
	local tc=g:GetFirst()
	local flag=0
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_EXTRA,1,nil) end 
end
function cm.xxfil(c,flag,mg) 
	return bit.band(c:GetType(),flag)~=0 and 
	(c:IsSynchroSummonable(nil,mg,1,99) or 
	 c:IsXyzSummonable(mg,1,99) or 
	 c:IsLinkSummonable(mg,nil,1,99))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local mg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local flag=e:GetLabel()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil) 
	if g:GetCount()<=0 then return end 
	Duel.ConfirmCards(tp,g)
	if g:IsExists(cm.xxfil,1,nil,flag,mg) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then  
	local tc=g:Filter(cm.xxfil,nil,flag,mg):Select(tp,1,1,nil):GetFirst()
	if tc:IsSynchroSummonable(nil,mg,1,99) then 
	Duel.SynchroSummon(1-tp,tc,nil,mg,1,99)
	end
	if tc:IsXyzSummonable(mg,1,99) then 
	Duel.XyzSummon(1-tp,tc,mg,1,99)
	end
	if tc:IsLinkSummonable(nil,mg,1,99) then 
	Duel.LinkSummon(1-tp,tc,mg,nil,1,99)
	end 
	end
end
--Effect 3 
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cm.val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.filter3,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*400
end
function cm.filter3(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
--Effect 4 
function cm.con4(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function cm.tg4(e,c)
	return c:IsFaceup()
end
--Effect 5
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	and Duel.CheckLocation(tp,LOCATION_PZONE,0) 
	or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() 
	 and not tc:IsDisabled()) 
	or tc:IsType(TYPE_TRAPMONSTER)) 
	and tc:IsRelateToEffect(e) 
	and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end   
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end