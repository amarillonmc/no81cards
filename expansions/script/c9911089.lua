--吸血鬼眷族·像素崩坏蜘蛛
function c9911089.initial_effect(c)
	aux.AddCodeList(c,9911056)
	--remove counter replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911089,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_RCOUNTER_REPLACE+0x1954)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911089.rcon)
	e1:SetOperation(c9911089.rop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911089)
	e2:SetCondition(c9911089.thcon1)
	e2:SetTarget(c9911089.thtg)
	e2:SetOperation(c9911089.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9911089.thcon2)
	c:RegisterEffect(e3)
	if not c9911089.global_check then
		c9911089.global_check=true
		local _DIsCanRemoveCounter=Duel.IsCanRemoveCounter
		local _DRemoveCounter=Duel.RemoveCounter
		function Duel.IsCanRemoveCounter(p,s,o,typ,ct,r)
			if typ~=0x1954 then return _DIsCanRemoveCounter(p,s,o,typ,ct,r) end
			c9911089.DRemoveCounter=Group.CreateGroup()
			local res1=_DIsCanRemoveCounter(p,s,o,typ,ct,r)
			if res1 then c9911089.DRemoveCounter=nil return res1 end
			if #c9911089.DRemoveCounter>0 then c9911089.DRemoveCounter=nil return true end
			c9911089.DRemoveCounter=nil
			return res1
		end
		function Duel.RemoveCounter(p,s,o,typ,ct,r)
			if typ~=0x1954 then return _DRemoveCounter(p,s,o,typ,ct,r) end
			c9911089.DRemoveCounter=Group.CreateGroup()
			local res1=_DIsCanRemoveCounter(p,s,o,typ,ct,r)
			local res2=#c9911089.DRemoveCounter>0
			if not res2 or (res1 and not Duel.SelectYesNo(p,aux.Stringid(9911089,0))) then
				c9911089.DRemoveCounter=nil
				return _DRemoveCounter(p,s,o,typ,ct,r)
			end
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local tg=c9911089.DRemoveCounter
			if #tg>1 then tg=tg:Select(p,1,1,nil) end
			Duel.SendtoGrave(tg,REASON_EFFECT+REASON_DISCARD)
			c9911089.DRemoveCounter=nil
			return true
		end
	end
end
function c9911089.rcon(e,tp,eg,ep,ev,re,r,rp)
	local lab=re:GetLabel()
	local res=re:IsActivated() and not (lab and lab==9911060) and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():IsDiscardable(REASON_EFFECT)
	if res and c9911089.DRemoveCounter then c9911089.DRemoveCounter:AddCard(e:GetHandler()) return false end
	return res
end
function c9911089.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
end
function c9911089.checkfilter(c)
	return c:IsCode(9911056) and c:IsFaceup()
end
function c9911089.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9911089.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911089.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9911089.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911089.thfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x8e) and c:IsAbleToHand()
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9911089.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911089.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c9911089.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	if not g1:IsExists(Card.IsControler,1,nil,1-tp) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c9911089.tgfilter(c)
	return c:IsSetCard(0x8e,0x9954) and c:IsAbleToGrave()
end
function c9911089.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup()
		local g2=Duel.GetMatchingGroup(c9911089.tgfilter,tp,LOCATION_DECK,0,nil)
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9911089,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg2,REASON_EFFECT)
		end
	end
end
