--远程型神威骑士  刻蒂亚（未解限）
function c24501043.initial_effect(c)
	-- 手卡起跳
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24501043)
	e1:SetCondition(c24501043.con1)
	e1:SetTarget(c24501043.tg1)
	e1:SetOperation(c24501043.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    -- 遗言检索
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24501043,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,24501044)
	e4:SetCondition(c24501043.con2)
	e4:SetTarget(c24501043.tg2)
	e4:SetOperation(c24501043.op2)
	c:RegisterEffect(e4)
end
-- 1
function c24501043.filter1(c,sp)
	return c:IsSummonPlayer(sp)
end
function c24501043.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c24501043.filter1,1,nil,1-tp)
end
function c24501043.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24501043.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-- 2
function c24501043.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c24501043.filter2(c)
	return c:IsSetCard(0x501) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c24501043.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501043.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501043.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501043.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
