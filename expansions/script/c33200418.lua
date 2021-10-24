--幻兽佣兵团 歌者-人鱼
function c33200418.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33200418.hspcon)
	e1:SetValue(c33200418.hspval)
	c:RegisterEffect(e1)	
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c33200418.aclimit)
	c:RegisterEffect(e2)
	--remove and tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200418,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33200418)
	e3:SetTarget(c33200418.rdtg)
	e3:SetOperation(c33200418.rdop)
	c:RegisterEffect(e3)
end

--e1
function c33200418.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c33200418.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c33200418.cfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c33200418.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c33200418.cfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end

--e2
function c33200418.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetColumnGroup():IsContains(tc)
end

--e3
function c33200418.rdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33200418.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c33200418.rdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200418.rdfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33200418.rdfilter,tp,0,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),1-tp,LOCATION_GRAVE)
end
function c33200418.rdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local rg=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	if rg~=0 and Duel.SelectYesNo(tp,aux.Stringid(33200418,1)) then
		Duel.ShuffleDeck(1-tp)
		Duel.BreakEffect()
		Duel.Recover(tp,rg*500,REASON_EFFECT)
	else
		Duel.ShuffleDeck(1-tp)
	end
end
