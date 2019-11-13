--忍法 影藏之术
function c40006899.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40006899+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c40006899.cost)
	e1:SetTarget(c40006899.thtg)
	e1:SetOperation(c40006899.thop)
	c:RegisterEffect(e1)	
end
function c40006899.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c40006899.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006899.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40006899.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetFirst():IsSetCard(0x2b) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40006899.thfilter(c,tp)
	return c:IsSetCard(0x61) and (c:GetType()==0x20002 or c:GetType()==0x20004) and c:GetActivateEffect():IsActivatable(tp)
end
function c40006899.thfilter1(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c40006899.thfilter2(c)
	return c:IsSetCard(0x2b) and c:IsLevelBelow(4) and c:IsSummonable(true,nil) 
end
function c40006899.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40006899.thfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
end
function c40006899.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006899.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c40006899.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40006899,1))
	local tc=Duel.SelectMatchingCard(tp,c40006899.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if e:GetLabel()==1 then
	local b1=Duel.GetMatchingGroup(c40006899.thfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	local b2=Duel.GetMatchingGroup(c40006899.thfilter1,tp,LOCATION_REMOVED,0,nil,e,tp)
	if (not b1 and not b2) or not Duel.SelectYesNo(tp,aux.Stringid(40006899,5)) then return end
	Duel.BreakEffect()
	local op=0
	if b1 and b2 then
	   op=Duel.SelectOption(tp,aux.Stringid(40006899,7),aux.Stringid(40006899,8))
	elseif b1 then
	   op=Duel.SelectOption(tp,aux.Stringid(40006899,7))
	else
	   op=Duel.SelectOption(tp,aux.Stringid(40006899,8))+1
	end
	if op==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	   local g=Duel.SelectMatchingCard(tp,c40006899.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local te=g:GetFirst()
	if te then
		Duel.Summon(tp,te,true,nil)
		   end
	 else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c40006899.thfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		 if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end		 
	  end
   end
end