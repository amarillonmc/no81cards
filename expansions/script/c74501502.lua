--不可视界限
function c74501502.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74501502,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c74501502.seqtg1)
	e1:SetOperation(c74501502.seqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(74501502,1))
	e2:SetTarget(c74501502.seqtg2)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(c74501502.tgcon)
	c:RegisterEffect(e3)
	--tohand/spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(74501502,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,74501502)
	e4:SetCost(c74501502.thcost)
	e4:SetTarget(c74501502.thtg)
	e4:SetOperation(c74501502.thop)
	c:RegisterEffect(e4)
end
function c74501502.rfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c74501502.lfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER)
end
function c74501502.seqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c74501502.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74501502.rfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74501502,2))
	Duel.SelectTarget(tp,c74501502.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c74501502.seqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c74501502.lfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74501502.lfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74501502,2))
	Duel.SelectTarget(tp,c74501502.lfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c74501502.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	c:AddCounter(0x1746,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c74501502.cfilter(c)
	return c:IsSetCard(0x745) and c:IsAbleToDeckOrExtraAsCost()
end
function c74501502.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1746)==2
end
function c74501502.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c74501502.cfilter,tp,LOCATION_GRAVE,0,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c74501502.cfilter,tp,LOCATION_GRAVE,0,2,2,c)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c74501502.thfilter(c)
	return c:IsCode(74516549) and c:IsAbleToHand()
end
function c74501502.filter(c)
	return c:IsCode(74546765)
end
function c74501502.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.IsExistingMatchingCard(c74501502.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c74501502.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,res)
	end
end
function c74501502.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c74501502.filter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c74501502.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:EnableDualState()
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
