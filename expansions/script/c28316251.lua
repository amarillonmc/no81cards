--闪耀的迷光 和泉爱依
function c28316251.initial_effect(c)
	--Straylight spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316251,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316251)
	e1:SetCondition(c28316251.spcon)
	e1:SetTarget(c28316251.sptg)
	e1:SetOperation(c28316251.spop)
	c:RegisterEffect(e1)
	--Straylight search→draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316251,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316251)
	e2:SetCost(c28316251.drcost)
	e2:SetTarget(c28316251.drtg)
	e2:SetOperation(c28316251.drop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_FLIP)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c28316251.thtg)
	e3:SetOperation(c28316251.thop)
	c:RegisterEffect(e3)
c28316251.shinycounter=true
end
function c28316251.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c28316251.ctfilter(c)
	return c:IsLevel(3) and c:IsFaceup() and c:IsCanAddCounter(0x1283,1)
end
function c28316251.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316251.ctfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316251.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local tc=Duel.SelectMatchingCard(tp,c28316251.ctfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local c=e:GetHandler()
	if tc:AddCounter(0x1283,1) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function c28316251.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1283,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1283,3,REASON_COST)
end
function c28316251.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c28316251.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c28316251.thfilter(c)
	return c.shinycounter and c:IsAbleToHand()
end
function c28316251.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316251.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28316251.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28316251.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
