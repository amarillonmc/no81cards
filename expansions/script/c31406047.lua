local m=31406047
local cm=_G["c"..m]
cm.name="月华之异界兽-洛霄"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_DECK)
	e2:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,31406000)
	e3:SetCost(cm.tdcost)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,31406000)
	--e4:SetCondition(cm.rmcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DEFENSE_ATTACK)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(cm.defcon)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetValue(aux.TRUE)
	e7:SetCondition(cm.defcon)
	c:RegisterEffect(e7)
end
function cm.filter(c)
	return c:IsAbleToHand() and c:IsCode(31450313)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	--if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		c:ReverseInDeck()
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--local tc=Duel.GetFirstMatchingCard(cm.filter,tp,LOCATION_DECK,0,nil)
		--if tc~=nil then
		--  Duel.SendtoHand(tc,tp,REASON_EFFECT)
		--  Duel.ConfirmCards(1-tp,tc)
		--end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x6311) and bit.band(re:GetCategory(),CATEGORY_DRAW)~=0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsPosition(POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.tdfilter(c)
	return c:IsAbleToHand() and c:IsCode(31406029)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
	local tg1=tg:Filter(Card.IsPosition,nil,POS_FACEUP_DEFENSE)
	local tg2=tg:__sub(tg1)
	local tc
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if tg1:GetCount()~=0 then
		if tg1:GetCount()==tg:GetCount() or Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			tc=tg1:GetFirst()
		else
			tc=tg2:GetFirst()
		end
	else
		tc=tg:GetFirst()
	end
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.rmconfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCode(31450043,31450313)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rmconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rmfilter(c)
	return c:IsAbleToHand() and c:IsCode(31406083)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.defcon(e)
	return e:GetHandler():IsPosition(POS_DEFENSE)
end