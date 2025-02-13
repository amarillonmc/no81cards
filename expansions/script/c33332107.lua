--澄炎转生
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,id)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(this.gsptg)
	e3:SetOperation(this.gspop)
	c:RegisterEffect(e3)
end
function this.tdfilter(c)
	return c:IsSetCard(0x6567) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and this.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(this.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,this.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function this.thspfilter(c,e,tp)
	return c:IsSetCard(0x6567) and c:IsFaceup() and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local sg=Duel.GetMatchingGroup(this.thspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ct>0 and Duel.Draw(tp,1,REASON_EFFECT)==1 and g:IsExists(Card.IsRace,1,nil,RACE_SPELLCASTER)
	and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg=sg:Select(tp,1,1,nil)
		local th=tg:GetFirst():IsAbleToHand()
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			res=Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		else
			res=Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function this.gspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x6567)  
end 
function this.gsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(this.gspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end 
function this.gspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(this.gspfil,tp,LOCATION_PZONE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 
