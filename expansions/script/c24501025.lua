--神威骑士皇
function c24501025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c24501025.sfilter),1)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,24501035,LOCATION_MZONE+LOCATION_GRAVE)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c24501025.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c24501025.effectfilter)
	c:RegisterEffect(e4)
	--destroy-monster
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24501025,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e5:SetCode(EVENT_CUSTOM+24501025)
	--e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c24501025.cost)
	e5:SetTarget(c24501025.destg)
	e5:SetOperation(c24501025.desop)
	c:RegisterEffect(e5)
	--aux.RegisterMergedDelayedEvent(c,24501025,EVENT_SPSUMMON_SUCCESS)
	--destroy-spell
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(24501025,1))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c24501025.cost)
	e6:SetTarget(c24501025.destg2)
	e6:SetOperation(c24501025.desop2)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(24501025,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c24501025.descon)
	e7:SetCost(c24501025.cost)
	e7:SetTarget(c24501025.destg3)
	e7:SetOperation(c24501025.desop3)
	c:RegisterEffect(e7)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(24501025,3))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c24501025.thtg)
	e8:SetOperation(c24501025.thop)
	c:RegisterEffect(e8)
end
function c24501025.sfilter(c)
	return c:IsSetCard(0x501) and c:IsType(TYPE_SYNCHRO)
end
--2
function c24501025.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x501)-- and bit.band(loc,LOCATION_ONFIELD)~=0
end
--3
function c24501025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c24501025.chkfilter(c)
	return c:IsSetCard(0x501) and c:IsFaceupEx()
end
function c24501025.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	local ct=Duel.GetMatchingGroupCount(c24501025.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,24501025)<ct end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,24501025,RESET_CHAIN,0,1)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c24501025.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	Duel.HintSelection(dg)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c24501025.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.GetMatchingGroupCount(c24501025.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,24501025)<ct end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,24501025,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c24501025.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	Duel.HintSelection(dg)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c24501025.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and (LOCATION_HAND+LOCATION_ONFIELD)&loc~=0
end
function c24501025.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c24501025.chkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return rc:IsRelateToEffect(re) and Duel.GetFlagEffect(tp,24501025)<ct end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,24501025,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c24501025.desop3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c24501025.thfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToHand()
end
function c24501025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501025.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501025.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(24501025,4)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsType(TYPE_CONTINUOUS) and not tc:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(24501025,5)) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
