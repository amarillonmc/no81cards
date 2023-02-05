--雅乐朋克 太鼓
function c29535693.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29535693,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,29535693)
	e1:SetCondition(c29535693.spcon)
	e1:SetTarget(c29535693.sptg)
	e1:SetOperation(c29535693.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29535693,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,29535694)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c29535693.rettg)
	e2:SetOperation(c29535693.retop)
	c:RegisterEffect(e2)
end
function c29535693.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL|TYPE_TRAP) and c:IsSetCard(0x171) 
end
function c29535693.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29535693.cfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil)
end
function c29535693.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29535693.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c29535693.filter(c)
	return c:IsSetCard(0x171) and c:IsAbleToDeck()
end
function c29535693.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29535693.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29535693.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c29535693.filter,tp,LOCATION_GRAVE,0,1,99,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*300)
end
function c29535693.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*600,REASON_EFFECT)
	end
end
