local s,id=GetID()
local CARD_RYOSHU=33310451
s.VHisc_WEAVENEST=true

function s.initial_effect(c)
	--①：将「斩烬织巢之刃 良秀」加入手卡，那之后可以丢弃手卡检索其他「织巢」怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：「织巢」怪兽被送去墓地的场合
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.rtcon)
	e2:SetTarget(s.rttg)
	e2:SetOperation(s.rtop)
	c:RegisterEffect(e2)

	--②：「织巢」怪兽被除外的场合
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--①：检索「斩烬织巢之刃 良秀」
function s.ryoshufilter(c)
	return c:IsCode(CARD_RYOSHU) and c:IsAbleToHand()
end

--①：检索卡名不同的「织巢」怪兽
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c.VHisc_WEAVENEST and not c:IsCode(CARD_RYOSHU) and c:IsAbleToHand()
end

function s.disfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ryoshufilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.ryoshufilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)

	if not Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil) then return end
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end

	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	if Duel.DiscardHand(tp,s.disfilter,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--②：本次事件中被送墓或表侧除外的「织巢」怪兽
function s.rtfilter(c)
	return c:IsType(TYPE_MONSTER) and c.VHisc_WEAVENEST 
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rtfilter,1,nil)
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end

	local g=eg:Filter(s.rtfilter,nil)
	g:KeepAlive()
	e:SetLabelObject(g)

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end

function s.tdfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsAbleToDeck()
end

function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()

	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		local dg=g:Filter(s.tdfilter,nil,e)
		if #dg>0 then
			Duel.SendtoDeck(dg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
	g:DeleteGroup()
end