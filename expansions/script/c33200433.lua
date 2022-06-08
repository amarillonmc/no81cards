--魔力联合 翠之恩惠
function c33200433.initial_effect(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200433,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200433)
	e1:SetCondition(c33200433.spcon1)
	e1:SetTarget(c33200433.sptg)
	e1:SetOperation(c33200433.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200433,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33200433)
	e2:SetCondition(c33200433.spcon2)
	e2:SetTarget(c33200433.sptg)
	e2:SetOperation(c33200433.spop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200433,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33200434)
	e3:SetCost(c33200433.tgcost)
	e3:SetTarget(c33200433.tgtg)
	e3:SetOperation(c33200433.tgop)
	c:RegisterEffect(e3)
end

--spsm
function c33200433.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 
end
function c33200433.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33200433.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect() 
		Duel.Draw(tp,1,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_SPELL) then Duel.SendtoGrave(tc,REASON_EFFECT) end
		Duel.ShuffleHand(tp)
	end 
end

function c33200433.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3329) and c:GetSummonPlayer()==tp
end
function c33200433.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200433.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

--e3
function c33200433.tgdfilter(c)
	return c:IsSetCard(0x3329) and c:IsAbleToGraveAsCost()
end
function c33200433.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200433.tgdfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c33200433.tgdfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function c33200433.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200433.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200433.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3329)
end
function c33200433.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c33200433.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200433.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if Duel.IsExistingMatchingCard(c33200433.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200433,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c33200433.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc and tc:IsAbleToHand() then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				Duel.ShuffleHand(tp)
			end
		end
	end
end
