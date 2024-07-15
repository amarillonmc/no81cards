--“敬畏”
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.toss_dice=true
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ap=Duel.GetTurnPlayer()
	if ap==tp then
		return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
	elseif ap==1-tp then
		return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc1,dc2=Duel.TossDice(tp,2)
	s.revere_op(dc1,Duel.GetTurnPlayer(),dc2)
	Duel.BreakEffect()
	s.revere_op(dc2,Duel.GetTurnPlayer(),dc1)
end
function s.revere_op(dc1,tp,dc2)
	if dc1==1 then
		Duel.Hint(24,0,aux.Stringid(id,1))
		local dc=dc1+dc2
		Duel.Damage(tp,dc*1500,REASON_EFFECT)
		if dc==2 then
			Duel.Hint(24,0,aux.Stringid(id,7))
			Duel.Damage(tp,8000,REASON_EFFECT)
		end
	elseif dc1==2 then
		Duel.Hint(24,0,aux.Stringid(id,2))
		local dc=dc1+dc2
		local tg=Duel.GetDecktopGroup(tp,dc)
		if #tg==0 then return end
		Duel.DisableShuffleCheck()
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	elseif dc1==3 then
		Duel.Hint(24,0,aux.Stringid(id,3))
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(tp,1)
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif dc1==4 then
		Duel.Hint(24,0,aux.Stringid(id,4))
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):RandomSelect(tp,1)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif dc1==5 then
		Duel.Hint(24,0,aux.Stringid(id,5))
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif dc1==6 then
		Duel.Hint(24,0,aux.Stringid(id,6))
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN):Select(tp,2,2,nil)
		if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 and dc1+dc2==12 then
			Duel.Hint(24,0,aux.Stringid(id,8))
			local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND)
			Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end