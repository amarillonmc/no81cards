--深海猎人启航
local m=88802038
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,88802004)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return   c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and aux.IsCodeListed(c,88802004) 
end
function cm.chkfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,88802004)
end
function cm.desfilter(c,tp,solve)
	return  c:IsType(TYPE_MONSTER) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	if  Duel.Draw(p,g:GetCount(),REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup()
		if  tc:FilterCount(cm.chkfilter,nil)~=0 and  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		   Duel.BreakEffect()
		   Duel.ConfirmCards(1-tp,tc)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		   if g:GetCount()==0 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			   g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,true)
		   end
		   local tc=g:GetFirst()
		   if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			 if sc:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			 end
		   end
		 end
	end
end