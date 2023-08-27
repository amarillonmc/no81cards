local m=53764008
local cm=_G["c"..m]
cm.name="天施土养"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.setcost)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
cm.has_text_type=TYPE_SPIRIT
function cm.afilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetAttribute()&ATTRIBUTE_ALL~=ATTRIBUTE_ALL
end
function cm.filter(c)
	return c:IsType(TYPE_SPIRIT) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_HAND,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local att1=ATTRIBUTE_ALL
	for tc in aux.Next(g1) do att1=att1&tc:GetAttribute() end
	if ATTRIBUTE_ALL-att1~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		res=res+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local rc1=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-att1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg1=g1:FilterSelect(tp,aux.NOT(Card.IsAttribute),1,1,nil,rc1)
		Duel.HintSelection(sg1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(rc1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sg1:GetFirst():RegisterEffect(e1)
	end
	local g2=Duel.GetMatchingGroup(cm.afilter,tp,LOCATION_HAND,0,nil)
	local att2=ATTRIBUTE_ALL
	for tc in aux.Next(g2) do att2=att2&tc:GetAttribute() end
	if ATTRIBUTE_ALL-att2~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		res=res+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local rc2=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-att2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc2=g2:FilterSelect(tp,aux.NOT(Card.IsAttribute),1,1,nil,rc2):GetFirst()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PUBLIC)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_ATTRIBUTE)
		e3:SetValue(rc2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e3)
	end
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) and res<2 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsControler(tp) and not c:IsPublic()
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.cfilter,1,nil,tp) end
	local g=eg:Filter(cm.cfilter,nil,tp)
	if g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
