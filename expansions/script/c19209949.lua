--探寻饥献的文献解读者
function c19209949.initial_effect(c)
	--draw&spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,19209949)
	e1:SetCost(c19209949.cost)
	e1:SetTarget(c19209949.target)
	e1:SetOperation(c19209949.operation)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209949,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209949+1)
	e2:SetCondition(c19209949.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209949.tdtg)
	e2:SetOperation(c19209949.tdop)
	c:RegisterEffect(e2)
end
function c19209949.gcheck(g,e,tp)
	return g:IsContains(e:GetHandler()) and (Duel.IsPlayerCanDraw(tp,#g) and Duel.IsPlayerCanDraw(1-tp,#g) or Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(c19209949.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,0))
end
function c19209949.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xb54) and not c:IsCode(19209949) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c19209949.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,true):Filter(Card.IsSetCard,nil,0xb54)
	if chk==0 then return rg:CheckSubGroup(c19209949.gcheck,1,#rg,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,c19209949.gcheck,false,1,#rg,e,tp)
	Duel.SetTargetParam(g:GetCount())
	aux.UseExtraReleaseCount(g,tp)
	Duel.Release(g,REASON_COST)
end
function c19209949.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	local b1=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c19209949.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,0)
	local b2=Duel.IsPlayerCanDraw(0,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)) and Duel.IsPlayerCanDraw(1,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
	local op=b1 and 1 or 2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(19209949,0),aux.Stringid(19209949,1))+1
	elseif b1 then Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(19209949,0))
	elseif b2 then Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(19209949,1))
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		--e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_DRAW)
		--e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
	end
end
function c19209949.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==1 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c19209949.spfilter,tp,LOCATION_GRAVE,0,1,math.min(ft,ct),nil,e,tp,1)
		if sg and #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		for p in aux.TurnPlayers() do Duel.Draw(p,ct,REASON_EFFECT) end
	end
end
function c19209949.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c19209949.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c19209949.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
