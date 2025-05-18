--涡潜渊 无底城邦乌加里特
function c10202929.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10202929,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c10202929.ntcon)
	e2:SetTarget(c10202929.nttg)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c10202929.chainop)
	c:RegisterEffect(e3)
	--todeck and draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10202929,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,10202929)
	e4:SetTarget(c10202929.drtg)
	e4:SetOperation(c10202929.drop)
	c:RegisterEffect(e4)
end
function c10202929.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c10202929.nttg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(5)
end
--2
function c10202929.chainop(e,tp,eg,ep,ev,re,r,rp)
	if aux.IsCodeListed(re:GetHandler(),22702055) and c:IsType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c10202929.chainlm)
	end
end
function c10202929.chainlm(e,rp,tp)
	return tp==rp
end
--3
function c10202929.tdfilter(c)
    return c:IsAbleToDeck()
    and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
    and (aux.IsCodeListed(c,22702055)
        or (c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER))
        or c:IsSetCard(0x177))
end
function c10202929.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10202929.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c10202929.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10202929.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,3,3,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(10202929,1)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end