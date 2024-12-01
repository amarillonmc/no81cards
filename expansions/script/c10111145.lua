function c10111145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111145,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10111145)
	e1:SetCost(c10111145.cost)
	e1:SetTarget(c10111145.target)
	e1:SetOperation(c10111145.activate)
	c:RegisterEffect(e1)
    	--Effect 2  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(10111145,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10111145.drtg)
	e2:SetOperation(c10111145.drop)
	c:RegisterEffect(e2)  
end
function c10111145.rfilter(c,tp)
	return c:IsSetCard(0x70) and c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c10111145.spfilter(c,e,tp)
	return c:IsSetCard(0xb6,0xb7,0xb8) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10111145.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>=g:GetCount() and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c10111145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local rg=Duel.GetReleaseGroup(tp):Filter(c10111145.rfilter,nil,tp)
	local sg=Duel.GetMatchingGroup(c10111145.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or 5
	local maxc=math.min(ft,rg:GetCount(),(Duel.GetMZoneCount(tp,rg)),sg:GetClassCount(Card.GetCode))
	if chk==0 then return maxc>0 and rg:CheckSubGroup(c10111145.fselect,1,maxc,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,c10111145.fselect,false,1,maxc,tp)
	e:SetLabel(g:GetCount())
	aux.UseExtraReleaseCount(g,tp)
	Duel.Release(g,REASON_COST)
end
function c10111145.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_EXTRA)
	Duel.SetChainLimit(c10111145.chlimit)
end
function c10111145.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=e:GetLabel()
	if ft<ct or ft<=0 then return end
	local g=Duel.GetMatchingGroup(c10111145.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10111145.chlimit(e,ep,tp)
	return tp==ep
end
function c10111145.tdfilter(c)
	local b1=c:IsSetCard(0xb6,0xb7,0xb8) and c:IsType(TYPE_MONSTER)
	return  b1 and c:IsAbleToDeck()
end
function c10111145.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10111145.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c10111145.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10111145.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10111145.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end