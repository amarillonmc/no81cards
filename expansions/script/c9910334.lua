--神神树勇者的散华
function c9910334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910334+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910334.cost)
	e1:SetTarget(c9910334.target)
	e1:SetOperation(c9910334.activate)
	c:RegisterEffect(e1)
end
function c9910334.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9910334.tdfilter(c)
	local lv=c:GetLevel()
	return lv>0 and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c9910334.cfilter,tp,LOCATION_EXTRA,0,1,nil,lv+4)
end
function c9910334.cfilter(c,lv)
	return c:IsSetCard(0x956) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and c:IsAbleToGraveAsCost()
end
function c9910334.tdfilter2(c,e)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_TUNER) and c:IsLevel(e:GetLabel()) and c:IsAbleToDeck()
end
function c9910334.cfilter2(c,lvgy)
	local lv=c:GetLevel()
	return c:IsSetCard(0x956) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
		and lv>4 and lvgy[lv-4] and lvgy[lv-4]>0
end
function c9910334.tdfilter3(c,lv)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_TUNER) and c:IsLevel(lv) and c:IsAbleToDeck()
end
function c9910334.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910334.tdfilter2(chkc,e) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9910334.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	local lvgy={}
	local gyg=Duel.GetMatchingGroup(c9910334.tdfilter,tp,LOCATION_GRAVE,0,nil)
	for gyc in aux.Next(gyg) do
		local gyl=gyc:GetLevel()
		if lvgy[gyl] then lvgy[gyl]=lvgy[gyl]+1 else lvgy[gyl]=1 end
	end
	local lvex={}
	local ct=0
	local flag=true
	while flag do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local exc=Duel.SelectMatchingCard(tp,c9910334.cfilter2,tp,LOCATION_EXTRA,0,1,1,nil,lvgy):GetFirst()
		local lv=exc:GetLevel()-4
		ct=ct+1
		lvex[ct]=lv
		lvgy[lv]=lvgy[lv]-1
		Duel.SendtoGrave(exc,REASON_COST)
		local exg=Duel.GetMatchingGroup(c9910334.cfilter2,tp,LOCATION_EXTRA,0,nil,lvgy)
		if ct>=3 or exg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(9910334,0)) then flag=false end
	end
	e:SetLabel(lvex)
	local ct2=1
	local g=Group.CreateGroup()
	while ct2<=ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=Duel.SelectTarget(tp,c9910334.tdfilter3,tp,LOCATION_GRAVE,0,1,1,g,lvex[ct2]):GetFirst()
		g:AddCard(tc)
		ct2=ct2+1
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c9910334.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct<=0 then return end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local ctt={}
	local ctp=1
	while ct>=ctp do
		ctt[ctp]=ctp
		ctp=ctp+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910334,1))
	local drct=Duel.AnnounceNumber(tp,table.unpack(ctt))
	drct=Duel.Draw(tp,drct,REASON_EFFECT)
	if drct>=2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	if drct==3 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9910334.splimit)
		if Duel.GetTurnPlayer()==tp then
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e2,tp)
	end
end
function c9910334.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PLANT)) and c:IsLocation(LOCATION_EXTRA)
end
