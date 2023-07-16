--海造贼--新生之集结号
function c67642779.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67642779.mfilter,c67642779.xyzcheck,3,99)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyzsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--pendulum
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(67642779,0))
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCountLimit(1,67642779) 
	e2:SetCost(c67642779.tpcost) 
	e2:SetTarget(c67642779.tddtg) 
	e2:SetOperation(c67642779.tddop) 
	c:RegisterEffect(e2) 
	--Select xyz material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67642779,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,67642780)
	e3:SetCost(c67642779.xyzcost)
	e3:SetOperation(c67642779.xyzop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67642779,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c67642779.discon)
	e4:SetCost(c67642779.discost)
	e4:SetTarget(c67642779.distg)
	e4:SetOperation(c67642779.disop)
	c:RegisterEffect(e4)
	--to hand and Draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67642779,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,67642781)
	e5:SetCost(c67642779.descost)
	e5:SetTarget(c67642779.destg)
	e5:SetOperation(c67642779.desop)
	c:RegisterEffect(e5)
end
--XyzSummon condition
function c67642779.mfilter(c)
	return c:IsSetCard(0x13f) and c:IsType(TYPE_RITUAL) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end
function c67642779.xyzcheck(g)
	return g:GetClassCount(Card.GetType)==#g
end
--pendulum 
function c67642779.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c67642779.tdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x13f)  
end 
function c67642779.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c67642779.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c67642779.tddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c67642779.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)  
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,5,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
		end
	end 
end 
--Select xyz material
function c67642779.xyzfilter1(c)
	return c:IsDiscardable() and c:IsSetCard(0x13f)
end
function c67642779.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67642779.xyzfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c67642779.xyzfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function c67642779.xyzfilter2(c)
	return c:IsOnField() and c:IsCanOverlay()
end
function c67642779.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67642779.xyzfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=g:Select(tp,1,1,nil)
		Duel.Overlay(c,og)
	end
end
--negate
function c67642779.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x13f) and p==tp and rp==1-tp
end
function c67642779.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67642779.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67642779)==0 end
	Duel.RegisterFlagEffect(tp,67642779,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c67642779.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--to hand and draw
function c67642779.desfilter(c,e,tp)
	return c:IsSetCard(0x13f) and c:IsAbleToHand() and c:GetSequence()<5
end
function c67642779.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetTargetCount(c67642779.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c67642779.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c67642779.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67642779.desfilter,tp,LOCATION_SZONE,0,1,nil)  end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,c67642779.desfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c67642779.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local cg=Duel.GetOperatedGroup()
	if cg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local gt=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
	if gt>0 then
		Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
end