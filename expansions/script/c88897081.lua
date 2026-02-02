--终驰冲击
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCost(s.cost)  
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,4))
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e11:SetCondition(s.condition)
	e11:SetTarget(s.target)
	e11:SetOperation(s.activate)
	c:RegisterEffect(e11)
end
function s.xcfilter(c)
	return c:IsFaceup() and (c:IsLevel(9) or c:IsRank(9))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.xcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter(c)  
	return c:IsSetCard(0xc0e) and not c:IsPublic()  
end  
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)  
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())  
	Duel.ConfirmCards(1-tp,g)  
	Duel.ShuffleHand(tp)  
end 
function s.tdfilter(c)
	return c:IsAbleToDeck()
end
function s.ovfilter_op(c)
	return c:IsCanOverlay() and not c:IsType(TYPE_TOKEN)
end
function s.ovfilter_my(c)
	return c:IsFaceup() and c:IsSetCard(0xc0e) and c:IsType(TYPE_XYZ)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.ovfilter_op,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(s.ovfilter_my,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.ovfilter_op,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(s.ovfilter_my,tp,LOCATION_MZONE,0,1,nil)
	local op=0
	if b1 then
		if not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local g1=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_ONFIELD,nil)
			if #g1>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg1=g1:Select(tp,1,1,nil)
				if #sg1>0 then
					Duel.HintSelection(sg1)
					Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			end
			op=1
		end
	end
	b2=Duel.IsExistingMatchingCard(s.ovfilter_op,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(s.ovfilter_my,tp,LOCATION_MZONE,0,1,nil)
	if b2 and (op==0 or ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		if op~=0 then
			Duel.BreakEffect()
		end
		local g2_op=Duel.GetMatchingGroup(s.ovfilter_op,tp,0,LOCATION_ONFIELD,nil)
		local g2_my=Duel.GetMatchingGroup(s.ovfilter_my,tp,LOCATION_MZONE,0,nil)
		if #g2_op>0 and #g2_my>0 then
			if did_something then Duel.BreakEffect() end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=g2_op:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local sc=g2_my:Select(tp,1,1,nil):GetFirst()
				if sc and not tc:IsImmuneToEffect(e) then
					Duel.HintSelection(Group.FromCards(tc,sc))
					local og=tc:GetOverlayGroup()
					if #og>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(sc,tc)
				end
			end
		end
	end
end