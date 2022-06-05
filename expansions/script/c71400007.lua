--异梦胡同的路标
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400007.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetDescription(aux.Stringid(71400007,0))
	e1:SetTarget(c71400007.tg1)
	e1:SetOperation(c71400007.op1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400007,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,71400007)
	e2:SetCondition(c71400007.con2)
	e2:SetTarget(c71400007.tg2)
	e2:SetOperation(c71400007.op2)
	c:RegisterEffect(e2)
	--gy banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetDescription(aux.Stringid(71400007,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71500007)
	e3:SetCost(c71400007.cost)
	e3:SetTarget(c71400007.target)
	e3:SetOperation(c71400007.operation)
	c:RegisterEffect(e3)
end
function c71400007.filter1(c)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD)
end
function c71400007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400007.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function c71400007.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c71400007.filter1,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c71400007.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c71400007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71400007.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c71400007.filter(c,e,tp,zone)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71400007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c71400007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c71400007.filter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0
		and Duel.IsExistingTarget(c71400007.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c71400007.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c71400007.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end