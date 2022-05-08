local m=60001081
local cm=_G["c"..m]
cm.name="闪刀姬-长夜露世"
function cm.initial_effect(c)
	c:SetSPSummonOnce(60001081)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1,1)
	aux.AddXyzProcedureLevelFree(c,cm.xfilter,nil,2,2)
	--rkchange
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_RANK)
	e0:SetValue(4)
	c:RegisterEffect(e0)
	--look look my deck!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)

	if not cm.rk2change then
		cm.rk2change=true
		_ace1GetRank=Card.GetRank
		function Card.GetRank(c)
			if (c:GetOriginalCode()==60001081 and c:IsLocation(LOCATION_EXTRA)) then return 4 end
			return _ace1GetRank(c)
		end
		_ace1GetOriginalRank=Card.GetOriginalRank
		function Card.GetOriginalRank(c)
			if c:GetOriginalCode()==60001081 then return 4 end
			return _ace1GetOriginalRank(c)
		end
		_ace1IsRank=Card.IsRank
		Card.IsRank=function(c,rk1,...)
			if not (c:GetOriginalCode()==60001081 and c:IsLocation(LOCATION_EXTRA)) then return _ace1IsRank(c,rk1,...) end
			if rk1==4 then return true end
			local t={...}
			for _,rk in pairs(t) do
				if rk==4 then return true end
			end
			return false
		end
		_ace1IsRankAbove=Card.IsRankAbove
		function Card.IsRankAbove(c,rk)
			if (c:GetOriginalCode()==60001081 and c:IsLocation(LOCATION_EXTRA)) and rk<=4 then return true end
			return _ace1IsRankAbove(c,rk)
		end
		_ace1IsRankBelow=Card.IsRankBelow
		function Card.IsRankBelow(c,rk)
			if (c:GetOriginalCode()==60001081 and c:IsLocation(LOCATION_EXTRA)) and rk>=4 then return true end
			return _ace1IsRankBelow(c,rk)
		end
	end
end
function cm.lfilter(c)
	return c:IsLinkSetCard(0x1115) and not c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function cm.xfilter(c,sc)
	return c:IsCanOverlay() and c:IsXyzLevel(sc,4)
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x115) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1115) and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	local x=0
	if ct>0 and g:FilterCount(cm.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.thfilter,1,ct,nil)
		x=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
	Duel.BreakEffect()
	if x==1 then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local ag=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if ag:GetCount()~=0 then
				Duel.HintSelection(ag)
				Duel.SendtoDeck(ag,nil,2,REASON_EFFECT)
			end
		end
	end
	if x>=2 then
		Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_EFFECT+REASON_DISCARD)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end