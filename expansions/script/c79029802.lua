--逆元构造 异火
function c79029802.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029802.spcon)
	c:RegisterEffect(e1)
	--t g
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029802)
	e2:SetCondition(c79029802.tgcon)
	e2:SetTarget(c79029802.detg)
	e2:SetOperation(c79029802.deop)
	c:RegisterEffect(e2)
	--ww
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c79029802.negcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029802.negtg)
	e3:SetOperation(c79029802.negop)
	c:RegisterEffect(e3)
end
function c79029802.xxfilter(c)
	return not c:IsLevel(3) and not c:IsRank(3) and not c:IsLink(3)
end
function c79029802.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	  not  Duel.IsExistingMatchingCard(c79029802.xxfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c79029802.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029802.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c79029802.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c79029802.filter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xa991) and c:IsFaceup()
end
function c79029802.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c79029802.filter,1,nil,tp) 
end
function c79029802.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79029802.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end