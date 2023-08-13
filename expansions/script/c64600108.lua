--黑 影 之 龙  空
local m=64600108
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,53129443)
	--link summon
	aux.AddLinkProcedure(c,nil,1,1,c64600108.lcheck)
	c:EnableReviveLimit()
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64600108,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,64600108)
	e1:SetCondition(c64600108.descon)
	e1:SetTarget(c64600108.destg)
	e1:SetOperation(c64600108.desop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64600108,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,64601108)
	e2:SetCondition(c64600108.drcon)
	e2:SetTarget(c64600108.drtg)
	e2:SetOperation(c64600108.drop)
	c:RegisterEffect(e2)
end
function c64600108.atk(e,c)
	return aux.IsCodeListed(c,53129443)
end
function c64600108.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c64600108.filter(c)
	return c:IsCode(53129443) and c:IsAbleToDeck()
end
function c64600108.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c64600108.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c64600108.drop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c64600108.filter,tp,LOCATION_GRAVE,0,nil)
	if sg:GetCount()>0 then
		local ct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c64600108.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,64600105)
end
function c64600108.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c64600108.spfilter(c,e,tp)
	return c:IsCode(72880377) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64600108.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c64600108.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c64600108.spfilter),tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(64600108,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
