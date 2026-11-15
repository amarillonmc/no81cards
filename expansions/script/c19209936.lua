--饥献的大天涯 伟大教义
function c19209936.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209936,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,19209936)
	e1:SetCost(c19209936.thcost)
	e1:SetTarget(c19209936.thtg)
	e1:SetOperation(c19209936.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209936,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,19209936)
	e2:SetCondition(c19209936.rlcon)
	e2:SetTarget(c19209936.rltg)
	e2:SetOperation(c19209936.rlop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c19209936.sptg)
	e3:SetOperation(c19209936.spop)
	c:RegisterEffect(e3)
end
function c19209936.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c19209936.thfilter(c)
	return c:IsSetCard(0xb54) and not c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19209936.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209936.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209936.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c19209936.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c19209936.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c19209936.ctfilter(c)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c19209936.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:IsExists(Card.IsReleasable,1,nil,REASON_RULE) and Duel.IsPlayerCanRelease(1-tp) and Duel.IsPlayerCanDraw(1-tp,1) end
	local ct=Duel.GetMatchingGroupCount(c19209936.ctfilter,tp,LOCATION_REMOVED,0,nil)+1
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,math.min(#g,ct),0,0)
end
function c19209936.rlop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c19209936.ctfilter,tp,LOCATION_REMOVED,0,nil)+1
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:Clone()
		if tg:GetCount()>ct then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			tg=tg:Select(1-tp,ct,ct,nil)
		end
		Duel.HintSelection(tg)
		if Duel.Release(tg,REASON_RULE,1-tp)~=0 then
			Duel.BreakEffect()
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
function c19209936.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c19209936.spfilter(c,e,tp)
	return c:IsCanHaveCounter(0xb55) and Duel.IsCanAddCounter(tp,0xb55,3,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()(c)
end
function c19209936.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209936.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:AddCounter(0xb55,3)
end
