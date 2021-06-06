local m=31405067
local cm=_G["c"..m]
cm.name="漆黑之异界兽-死棱黑镜"
function cm.initial_effect(c)
	aux.AddCodeList(c,31405079,31405109)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(1)
	e2:SetDescription(aux.Stringid(m,1))
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.tdcost)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	--e4:SetCondition(cm.rmcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.chainlm(e,rp,tp)
	return false
end
function cm.counterfilter(c)
	return c:IsLevel(7) and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.cfilter(c,label)
	local code
	if label==0 then code=31406029 end
	if label==1 then code=31406047 end
	return c:IsReleasable() and c:IsCode(code)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lb=e:GetLabel()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,lb) end
	local tg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil,lb)
	local tg1=tg:Filter(Card.IsPosition,nil,POS_FACEUP_DEFENSE)
	local tg2=tg:__sub(tg1)
	local tc
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if tg1:GetCount()~=0 then
		if tg1:GetCount()==tg:GetCount() or Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			tc=tg1:GetFirst()
		else
			tc=tg2:GetFirst()
		end
	else
		tc=tg:GetFirst()
	end
	if tc:IsPosition(POS_FACEUP_DEFENSE) then
		Duel.SetChainLimit(cm.chainlm)
	end
	Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not cm.counterfilter(c)
end
function cm.spfilter(c,e,tp,label)
	local pos,code
	if label==0 then
		pos=POS_FACEUP_ATTACK
		code=31405079
	end
	if label==1 then
		pos=POS_FACEUP_DEFENSE
		code=31405109
	end
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,pos) and c:IsCode(code) and (c:IsLocation(LOCATION_HAND) or c:IsPosition(POS_FACEUP_DEFENSE))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local lb=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lb):GetFirst()
	local pos
	if lb==0 then pos=POS_FACEUP_ATTACK end
	if lb==1 then pos=POS_FACEUP_DEFENSE end
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,pos)
	end
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.tdfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x9311)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
	local tg1=tg:Filter(Card.IsPosition,nil,POS_FACEUP_DEFENSE)
	local tg2=tg:__sub(tg1)
	local tc
	if tg1:GetCount()~=0 then
		if tg1:GetCount()==tg:GetCount() or Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			tc=tg1:Select(tp,1,1,nil)
		else
			tc=tg2:Select(tp,1,1,nil)
		end
	else
		tc=tg:Select(tp,1,1,nil)
	end
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.rmconfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCode(31405151)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.rmconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rmfilter(c)
	return c:IsAbleToHand() and c:IsCode(31405277)
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