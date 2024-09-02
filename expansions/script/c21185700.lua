--阿巴阿巴王
function c21185700.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21185700.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c21185700.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21185700)
	e3:SetTarget(c21185700.tg3)
	e3:SetOperation(c21185700.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,21185701)
	e4:SetCost(c21185700.cost4)
	e4:SetTarget(c21185700.tg4)
	e4:SetOperation(c21185700.op4)
	c:RegisterEffect(e4)	
end
function c21185700.q(c)
	return c:IsSetCard(0x910) and c:IsType(TYPE_MONSTER)
end
function c21185700.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c21185700.q,tp,LOCATION_GRAVE,0,nil)
	return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c21185700.atkval(e,c)
	return Duel.GetMatchingGroup(c21185700.q,c:GetControler(),LOCATION_GRAVE,0,nil):GetCount()*300
end
function c21185700.w(c)
	return c:IsSetCard(0x910) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(21185700)
end
function c21185700.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21185700.w,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21185700.w,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c21185700.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	end
end
function c21185700.e(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c21185700.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c21185700.e,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c21185700.e,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c21185700.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c21185700.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end