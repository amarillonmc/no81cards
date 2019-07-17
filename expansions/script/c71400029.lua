--梦之方块间的围巾少女
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400029.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,71400029)
	e1:SetTarget(c71400029.tg1)
	e1:SetCondition(c71400029.con1)
	e1:SetOperation(c71400029.op1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400029,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c71400029.tg2)
	e2:SetOperation(c71400029.op2)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	Duel.AddCustomActivityCounter(71400029,ACTIVITY_CHAIN,c71400029.chainfilter)
end
function c71400029.chainfilter(re,tp,cid)
	return not re:GetHandler():IsSetCard(0xa714)
end
function c71400029.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(71400029,tp,ACTIVITY_CHAIN)>0
end
function c71400029.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71400029.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71400029.filter2(c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0xb714) and c:IsAbleToHand()
end
function c71400029.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400029.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400029.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c71400029.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c71400029.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end