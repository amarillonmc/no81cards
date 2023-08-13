--黑 影 育 爱
local m=64600103
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,53129443)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c64600103.condition)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,64600103)
	e3:SetCost(c64600103.tdcost)
	e3:SetTarget(c64600103.tdtg)
	e3:SetOperation(c64600103.tdop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,64601103)
	e4:SetCondition(c64600103.spcon)
	e4:SetTarget(c64600103.sptg)
	e4:SetOperation(c64600103.spop)
	c:RegisterEffect(e4)
	
end
function c64600103.condition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c64600103.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c64600103.tdfilter(c)
	return aux.IsCodeListed(c,53129443) and c:IsAbleToDeck()
end
function c64600103.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local crt=Duel.GetTargetCount(c64600103.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then crt=1 end
	if crt>tt then crt=tt end
	if crt>3 then crt=3 end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c64600103.tdfilter(chkc) end
	if chk==0 then return crt>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,64600104,nil,TYPES_TOKEN_MONSTER,3000,3000,3,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c64600103.tdfilter,tp,LOCATION_GRAVE,0,1,crt,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,e:GetLabel(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c64600103.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,64600104,nil,TYPES_TOKEN_MONSTER,3000,3000,ct,RACE_FIEND,ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		for i=1,ct do
			local token=Duel.CreateToken(tp,64600104)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		end
	end
end
function c64600103.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and not c:GetReasonEffect():IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c64600103.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64600103.cfilter,1,nil)
end
function c64600103.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,64600105,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c64600103.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,64600105,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,64600105)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end










