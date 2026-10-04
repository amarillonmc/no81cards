--蚀痕无命 艾尔琳达
function c62501721.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501721,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,62501721)
	e1:SetCondition(c62501721.spcon)
	e1:SetCost(c62501721.spcost)
	e1:SetTarget(c62501721.sptg)
	e1:SetOperation(c62501721.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501721+1)
	e2:SetTarget(c62501721.rectg)
	e2:SetOperation(c62501721.recop)
	c:RegisterEffect(e2)
	c62501721.remove_event_effect=e2
end
function c62501721.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c62501721.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	--Duel.ConfirmDecktop(tp,3)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	--g:KeepAlive()
	Duel.SetTargetCard(g)
end
function c62501721.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501721.sfilter(c,e,tp)
	return c:IsSetCard(0xea4) and (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSSetable()) and c:IsControler(tp)
end
function c62501721.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 or not g then return end
	if g:IsExists(c62501721.sfilter,1,nil,e,tp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:FilterSelect(tp,c62501721.sfilter,1,1,nil,e,tp):GetFirst()
		if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(62501721,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(62501721,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
	--g:DeleteGroup()
end
function c62501721.efilter(e)
	local ct=#c62501721.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501721.effect_list[ct+1]=e end
	return false
end
function c62501721.rmfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xea4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEDOWN)) then return false end
	local te=c.remove_event_effect
	if not te then return false end
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501721.effect_list={}
	c:IsOriginalEffectProperty(c62501721.efilter)
	for _,te in ipairs(c62501721.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end]]
	e:SetCostCheck(check)
	return false
end
function c62501721.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*100)
end
function c62501721.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if Duel.Recover(tp,Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*100,REASON_EFFECT)==0 or #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(62501721,1)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,3,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
