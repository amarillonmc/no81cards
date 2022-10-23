--深空 光明神 布莱特
function c72101202.initial_effect(c)
	c:SetUniqueOnField(1,1,72101202)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c72101202.lcheck)
	c:EnableReviveLimit()

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101202,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetTarget(c72101202.seatg)
	e1:SetOperation(c72101202.seaop)
	c:RegisterEffect(e1)

	--effect 
		--1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101202,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,72101202)
	e2:SetRange(LOCATION_MZONE,0)
	e2:SetTarget(c72101202.efftg)
	e2:SetOperation(c72101202.effop)
	c:RegisterEffect(e2)
		--2
	local e15=e2:Clone()
	e15:SetType(EFFECT_TYPE_QUICK_O)
	e15:SetCode(EVENT_FREE_CHAIN)
	e15:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e15:SetCondition(c72101202.efcon)
	c:RegisterEffect(e15)
		--3
	local e16=e2:Clone()
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e16:SetCost(c72101202.effcost)
	e16:SetCondition(c72101202.effcon)
	c:RegisterEffect(e16)
	
	--position change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(72101202,4))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c72101202.pccon)
	e5:SetTarget(c72101202.pctg)
	e5:SetOperation(c72101202.pcop)
	c:RegisterEffect(e5)

	--changdi zhaohuan bubei wuxiao
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c72101202.cdval)
	c:RegisterEffect(e9)
	--changdi zhaohuan buneng fadong
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCondition(c72101202.cdcon)
	e10:SetOperation(c72101202.cdop)
	c:RegisterEffect(e10)


end

--link summon
function c72101202.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT)
end

--search
function c72101202.seafilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsAbleToHand() and c:IsSetCard(0xcea)
end
function c72101202.seatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101202.seafilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72101202.seaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c72101202.seafilter,tp,LOCATION_DECK,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--effect
	--1
function c72101202.diufilter(c)
	return c:IsSetCard(0xcea) and c:IsDiscardable()
end
function c72101202.setfilter(c)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c72101202.upfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function c72101202.backfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c72101202.fktg(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c72101202.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c72101202.diufilter,tp,LOCATION_HAND,0,nil)
		local dt=Duel.GetMatchingGroupCount(c72101202.setfilter,tp,LOCATION_DECK,0,nil)
		local et=Duel.GetMatchingGroupCount(c72101202.upfilter,tp,0,LOCATION_MZONE,nil)
		local sel=0
		--1-1
		if ct>0 and dt>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			then sel=sel+1 
		end
		--1-2
		if et>0
			then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	--1--
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(72101202,0))
		sel=Duel.SelectOption(tp,aux.Stringid(72101202,2),aux.Stringid(72101202,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(72101202,2))
	else
		Duel.SelectOption(tp,aux.Stringid(72101202,3))
	end
	e:SetLabel(sel)
	--1-1
	if sel==1 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
	--1-2
	else
		local et=Duel.GetMatchingGroupCount(c72101202.upfilter,tp,0,LOCATION_MZONE,nil)
		e:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,et,0,LOCATION_MZONE)
	end
end
function c72101202.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	--1-1
	if sel==1 then
		local ct=Duel.GetMatchingGroupCount(c72101202.diufilter,tp,LOCATION_HAND,0,nil)
		local dt=Duel.GetMatchingGroupCount(c72101202.setfilter,tp,LOCATION_DECK,0,nil)
		local g=Duel.GetMatchingGroup(c72101202.diufilter,tp,LOCATION_HAND,0,nil)
		if ct>0 and dt>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			--to diu
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.SendtoGrave(dg,REASON_DISCARD+REASON_EFFECT)
			--to set
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,c72101202.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if tc then 
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
			end
		end 
	--1-2
	else
		local et=Duel.GetMatchingGroupCount(c72101202.upfilter,tp,0,LOCATION_MZONE,nil)
		local h=Duel.GetMatchingGroup(c72101202.upfilter,tp,0,LOCATION_MZONE,nil)
		if et>0 then
			Duel.ChangePosition(h,POS_FACEUP_ATTACK)
			--fankai xiaoguo wuxiao
			local r=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
			local rc=r:GetFirst()
			while rc do
				Duel.NegateRelatedChain(rc,RESET_TURN_SET)
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_DISABLE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e11)
				local e12=Effect.CreateEffect(e:GetHandler())
				e12:SetType(EFFECT_TYPE_SINGLE)
				e12:SetCode(EFFECT_DISABLE_EFFECT)
				e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e12:SetReset(RESET_EVENT+RESETS_STANDARD)
				e12:SetValue(RESET_TURN_SET)
				rc:RegisterEffect(e12)
				rc=r:GetNext()
			end
		end
		local j=Duel.GetMatchingGroup(c72101202.backfilter,tp,LOCATION_REMOVED,0,nil)
		local jt=j:GetCount()
		if jt>0 and Duel.SelectYesNo(tp,aux.Stringid(72101202,5)) then
			Duel.SendtoDeck(j,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.BreakEffect()
			if Duel.IsPlayerCanDraw(tp,jt) and jt<4 then
				Duel.Draw(tp,jt,REASON_EFFECT)
			elseif Duel.IsPlayerCanDraw(tp,3) then
				Duel.Draw(tp,3,REASON_EFFECT)
			else return end
		end
	end
end
	--2
function c72101202.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and Duel.GetTurnPlayer()==tp
end
	--3
function c72101202.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c72101202.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and not (Duel.GetTurnPlayer()==tp)
end

--positon change
function c72101202.pccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c72101202.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end
function c72101202.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c72101202.pcfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c72101202.pcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72101202.pcfilter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end

--changdi zhaohuan bubei wuxiao
function c72101202.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
--changdi zhaohuan chenggong bufadong
function c72101202.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101202.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101202.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101202.genchainlm(e:GetHandler()))
end
