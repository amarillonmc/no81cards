local m=15000734
local cm=_G["c"..m]
cm.name="噩梦茧机蜻·琳蒂"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,15000734)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
c15000734.pendulum_level=2
function cm.ovfilter(c)
	return c:GetEffectCount(15000724)~=0
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return e:GetHandler():IsRank(2,3) end
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x6f38) and c:IsType(TYPE_PENDULUM)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():GetOverlayGroup():GetCount()>=1 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler():GetOverlayGroup(),e:GetHandler():GetOverlayGroup():GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetHandler():GetOverlayGroup():GetCount(),tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
		local num=Duel.GetOperatedGroup():GetCount()
		local tc=g:GetFirst()
		while tc do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			tc=g:GetNext()
		end
		Duel.SortDecktop(tp,tp,g:GetCount())
		local ag=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,num,nil)
		if ag:GetCount()~=0 and Duel.SendtoHand(ag,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,ag)
			if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) then
				Duel.BreakEffect()
				Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)~=0 then
			if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
				if sg:GetCount()>0 then
					Duel.Summon(tp,sg:GetFirst(),true,nil)
				end
			end
		end
	end
end