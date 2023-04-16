--环门
function c65130334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130334,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65130334)
	e1:SetLabelObject(Group.CreateGroup())
	e1:SetCondition(c65130334.spcon)
	e1:SetTarget(c65130334.sptg)
	e1:SetOperation(c65130334.spop)
	c:RegisterEffect(e1)
	--to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130334,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65130334.tdtg)
	e2:SetOperation(c65130334.tdop)
	c:RegisterEffect(e2)
end
function c65130334.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c65130334.spfilter(c,e,tp)
	local scg=e:GetLabelObject()
	scg=Group.__add(scg,c)	
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and scg:GetClassCount(Card.GetCode)==scg:GetCount()
end
function c65130334.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65130334.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_DECK)
end
function c65130334.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c65130334.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=sg:RandomSelect(tp,1)
	local tc=tg:GetFirst()
	local cid=tc:GetCode()
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local scg=Group.CreateGroup()
	Group.AddCard(scg,tc)
	scg:KeepAlive()
	e:SetLabelObject(scg)
	while num>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetCount()>0 and tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) do
		sg=Duel.GetMatchingGroup(c65130334.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		tg=sg:RandomSelect(tp,1)
		tc=tg:GetFirst()
		Group.AddCard(scg,tc)
		e:SetLabelObject(scg)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=0 end
		num=num-1
	end
	Duel.SpecialSummonComplete()
end
function c65130334.cfilter(c)   
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsAbleToDeck()
end
function c65130334.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c65130334.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65130334.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c65130334.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
