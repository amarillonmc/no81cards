--午夜战栗·幽灵和声
function c10200055.initial_effect(c)
	--①：卡名在场上·墓地当作腐朽伴舞
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(10200048)
	c:RegisterEffect(e1)
	--②：丢弃检索同名卡不在墓地的午夜战栗怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200055,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10200056)
	e2:SetCost(c10200055.thcost)
	e2:SetTarget(c10200055.thtg)
	e2:SetOperation(c10200055.thop)
	c:RegisterEffect(e2)
	--③：墓地存在，午夜战栗怪兽移动或表示形式变更时特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200055,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+0xe25)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10200055)
	e3:SetCondition(c10200055.spcon)
	e3:SetTarget(c10200055.sptg)
	e3:SetOperation(c10200055.spop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_CHANGE_POS)
	e3b:SetCondition(c10200055.spcon2)
	c:RegisterEffect(e3b)
end
--②效果
function c10200055.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10200055.thfilter(c,tp)
	if not c:IsSetCard(0xe25) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToHand() then return false end
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c10200055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200055.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200055.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200055.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--③效果
function c10200055.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe25) and c:IsControler(tp)
end
function c10200055.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200055.cfilter,1,nil,tp)
end
function c10200055.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp) return c:IsFaceup() and c:IsSetCard(0xe25) and c:IsControler(tp) end,1,nil,tp)
end
function c10200055.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10200055.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--离场时除外
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
