--大庭院的月桂 洛莉艾尔
function c72404131.initial_effect(c)
	--spsummon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72404131,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,72404131)
	e1:SetCost(c72404131.cost1)
	e1:SetTarget(c72404131.target1)
	e1:SetOperation(c72404131.operation1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72404131,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c72404131.cost2)
	e2:SetTarget(c72404131.target2)
	e2:SetOperation(c72404131.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72404131,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,72404132)
	e3:SetCondition(c72404131.condition3)
	e3:SetTarget(c72404131.target3)
	e3:SetOperation(c72404131.operation3)
	c:RegisterEffect(e3)
end

--e1
function c72404131.costfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) 
		and Duel.GetMZoneCount(tp,c,tp)>0
end
function c72404131.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c72404131.costfilter,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c72404131.costfilter,1,1,e:GetHandler(),e,tp)
	Duel.Release(g,REASON_COST)
end
function c72404131.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72404131.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--e2
function c72404131.costfilter2(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable() and  c:IsLocation(LOCATION_HAND)
end
function c72404131.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c72404131.costfilter2,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectReleaseGroupEx(tp,c72404131.costfilter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c72404131.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72404131.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--e3
function c72404131.confilter3(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c72404131.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72404131.confilter3,1,e:GetHandler(),tp)
end
function c72404131.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x720) and c:IsAbleToHand()
end
function c72404131.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c72404131.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72404131.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c72404131.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c72404131.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
