--枢机神官·哀悼之灰
local cm,m,o=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--shuffle and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
if not cm.num then
	cm.num=0
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x647)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and #g==0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-ht)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-ht)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local hg=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	if #hg~=0 then return end
	
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<5 then
		if Duel.Draw(p,5-ht,REASON_EFFECT)~=0 then
			local mg=Duel.GetOperatedGroup()
			local tc=mg:GetFirst()
			for i=1,#mg do
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				tc=mg:GetNext()
			end
			cm.num=#Duel.GetOperatedGroup()
			
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetCondition(cm.rcon)
			e1:SetOperation(cm.rop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.sfil(c)
	return c:GetFlagEffect(m)~=0
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	return cm.num~=#g
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	cm.num=#g
	Duel.Readjust()
	if cm.num==0 then e:Reset() end
end

function cm.tdfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end