--AST 米尔特蕾德
function c33400423.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33400423)
	e1:SetCondition(c33400423.spcon)   
	e1:SetTarget(c33400423.sptg)
	e1:SetOperation(c33400423.spop)
	c:RegisterEffect(e1)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400423,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33400423.condition)
	e4:SetCountLimit(1,33400423+10000)
	e4:SetTarget(c33400423.drtg)
	e4:SetOperation(c33400423.drop)
	c:RegisterEffect(e4)
end
function c33400423.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
		and c:IsPreviousSetCard(0x9343) 
end
function c33400423.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400423.cfilter,1,nil,tp)
end
function c33400423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33400423.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c33400423.cnfilter(c)
	return c:IsSetCard(0x6343) or (c:IsSetCard(0x9343) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsFaceup()
end
function c33400423.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400423.cnfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c33400423.tdfilter(c)
	return c:IsSetCard(0x6343) or c:IsSetCard(0x9343) and c:IsAbleToDeck()
end
function c33400423.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400423.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c33400423.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33400423.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33400423.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		if  (Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341) and 
		   not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341)
			)
		or
		  (not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) and
		   Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
			(Duel.IsExistingMatchingCard(c33400423.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
			Duel.IsExistingMatchingCard(c33400423.cccfilter2,tp,LOCATION_MZONE,0,1,nil))
		  ) then   
			if   Duel.SelectYesNo(tp,aux.Stringid(33400423,1)) then 
			  Duel.Draw(tp,1,REASON_EFFECT)
			end 
	   end
	end
end
function c33400423.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400423.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end