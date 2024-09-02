--极恶堕落巫师
function c9911617.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911617)
	e1:SetTarget(c9911617.sptg)
	e1:SetOperation(c9911617.spop)
	c:RegisterEffect(e1)
	--buff
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetValue(c9911617.lvval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c9911617.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9911618)
	e5:SetTarget(c9911617.sumtg)
	e5:SetOperation(c9911617.sumop)
	c:RegisterEffect(e5)
	if not c9911617.global_flag then
		c9911617.global_flag=true
		c9911617[0]=0
		c9911617[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c9911617.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9911617.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911617.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct0=eg:FilterCount(Card.IsControler,nil,0)
	local ct1=eg:FilterCount(Card.IsControler,nil,1)
	c9911617[0]=c9911617[0]+ct0
	c9911617[1]=c9911617[1]+ct1
end
function c9911617.clearop(e,tp,eg,ep,ev,re,r,rp)
	c9911617[0]=0
	c9911617[1]=0
end
function c9911617.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
end
function c9911617.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c9911617.tdfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9911617.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9911617.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911617.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local sg=Duel.GetTargetsRelateToChain()
	if #sg==0 then return end
	aux.PlaceCardsOnDeckBottom(tp,sg)
	local og=Duel.GetOperatedGroup()
	local dr=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local drc=math.floor(dr/3)
	if drc>0 and Duel.IsPlayerCanDraw(tp,drc) and Duel.SelectYesNo(tp,aux.Stringid(9911617,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,drc,REASON_EFFECT)
	end
end
function c9911617.lvval(e,c)
	return c9911617[c:GetControler()]
end
function c9911617.atkval(e,c)
	return c9911617[c:GetControler()]*1000
end
function c9911617.sumfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSummonable(true,nil)
end
function c9911617.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911617.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9911617.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911617.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
