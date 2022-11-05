--创生之础
function c9910816.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,9910816)
	e2:SetCost(c9910816.spcost)
	e2:SetTarget(c9910816.sptg)
	e2:SetOperation(c9910816.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910816,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910817)
	e3:SetCondition(c9910816.tgcon)
	e3:SetTarget(c9910816.tgtg)
	e3:SetOperation(c9910816.tgop)
	c:RegisterEffect(e3)
end
function c9910816.thcfilter(c,tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c9910816.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c9910816.thcfilter,1,nil,tp)
end
function c9910816.thfilter(c)
	return c:IsSetCard(0x6951) and c:GetCode()~=9910816 and c:IsAbleToHand()
end
function c9910816.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910816.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910816.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910816.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910816.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function c9910816.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910816.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910816.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local off=1
	local ops={}
	local opval={}
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,9910801,0x6951,0x4011,0,500,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,9910802,0x6951,0x4011,500,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT)
	if b1 then
		ops[off]=aux.Stringid(9910816,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910816,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 or not Duel.SelectYesNo(tp,aux.Stringid(9910816,0)) then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local token=nil
	if opval[op]==1 then
		token=Duel.CreateToken(tp,9910801)
	elseif opval[op]==2 then
		token=Duel.CreateToken(tp,9910802)
	end
	Duel.BreakEffect()
	if token then Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910816.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c9910816.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x6951) and rp==tp and re:GetHandler()~=e:GetHandler()
end
function c9910816.tgfilter(c)
	return c:IsSetCard(0x6951) and c:IsAbleToGrave()
end
function c9910816.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910816.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910816.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910816.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
