--炼金工房秘密藏身处
function c75011031.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75011031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75011031.target)
	e1:SetOperation(c75011031.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1191)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c75011031.tgcon1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75011031.tgtg)
	e2:SetOperation(c75011031.tgop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCondition(c75011031.tgcon2)
	c:RegisterEffect(e5)
end
function c75011031.cfilter(c,e,tp)
	return c:IsSetCard(0x75e) and c:IsType(TYPE_MONSTER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and Duel.GetMZoneCount(tp)>0 or c:IsAbleToHand())
end
function c75011031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011031.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75011031.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c75011031.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c75011031.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011031.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011031.chkfilter,1,nil,tp,rp)
end
function c75011031.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and rp==tp
end
function c75011031.tgfilter(c)
	return c:IsCode(75011031) and c:IsAbleToGrave()
end
function c75011031.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011031.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75011031.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75011031.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
