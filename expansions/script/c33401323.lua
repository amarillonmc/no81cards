--希望的余晖
local m=33401323
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.ckfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local s1=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return s1>0 and  Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=s1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	 local s2=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	 if e:GetLabel()~=0 then
	Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.thfilter(c)
	return c:IsSetCard(0x341,0x340) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local s1=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=s1 then 
		Duel.ConfirmDecktop(tp,s1)
		local g=Duel.GetDecktopGroup(tp,s1)  
		local ct=g:GetClassCount(Card.GetCode)
		if ct==s1 then
			local thg=g:Filter(cm.thfilter,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=thg:Select(tp,1,1,nil)
			if g1:GetCount()>0 and g1:GetFirst():IsAbleToHand() then
			  Duel.SendtoHand(g1,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,g1)
			  Duel.ShuffleHand(p)
			  g:RemoveCard(g1:GetFirst())
			else 
			Duel.SendtoGrave(g1,REASON_RULE)
			end
			Duel.SendtoGrave(g,REASON_EFFECT)
			 local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
			if dg:GetClassCount(Card.GetCode)==dg:GetCount()  then
				local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
				Duel.ConfirmCards(tp,hg)
				Duel.ConfirmCards(1-tp,hg)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetTargetRange(LOCATION_ONFIELD,0)
				e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x341,0x340))
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetValue(cm.efilter)
				Duel.RegisterEffect(e1,tp)
				if  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g3=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
					Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		else
			local thg=g:Filter(cm.thfilter,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=thg:Select(tp,1,1,nil)
			if g1:GetCount()>0 and g1:GetFirst():IsAbleToHand() then
			  Duel.SendtoHand(g1,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,g1)
			  Duel.ShuffleHand(p)
			  g:RemoveCard(g1:GetFirst())
			else 
			Duel.SendtoGrave(g1,REASON_RULE)
			end
			local spg=g:Filter(cm.spfilter,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=thg:Select(tp,1,1,nil)
			if g2:GetCount()>0 then
			  Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
			 Duel.ShuffleDeck(tp)
		end
	end
end
