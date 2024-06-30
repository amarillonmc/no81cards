--Antonymph's Little Giant
function c31021001.initial_effect(c)
	--Summon Proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31021001.spcon)
	e1:SetOperation(c31021001.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c31021001.condition)
	e2:SetTarget(c31021001.target)
	e2:SetOperation(c31021001.operation)
	e2:SetCountLimit(1,31021001)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c31021001.addcon)
	e3:SetTarget(c31021001.addtg)
	e3:SetOperation(c31021001.addop)
	e3:SetCountLimit(1,31021002)
	c:RegisterEffect(e3)
end
function c31021001.spfilter(c,ft,tp)
	return c:IsSetCard(0x893)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c31021001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroupEx(tp,c31021001.spfilter,1,REASON_SPSUMMON,false,nil,ft,tp)
end
function c31021001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroupEx(tp,c31021001.spfilter,1,1,REASON_SPSUMMON,false,nil,ft,tp)
	Duel.Release(g,REASON_SPSUMMON)
end

function c31021001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c31021001.filter(c,e)
	return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false)
end
function c31021001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31021001.filter(chkc,e) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c31021001.filter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c31021001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,nil,tp,false,false) then
		Duel.SpecialSummon(tc,nil,tp,tp,false,false,POS_FACEUP)
	end
end

function c31021001.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack() <= 1500
end
function c31021001.addfilter(c)
	return c:IsSetCard(0x893) and c:IsAbleToHand()
end
function c31021001.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31021001.addfilter,tp,LOCATION_DECK,nil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,nil,0,0)
end
function c31021001.addop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31021001.addfilter,tp,LOCATION_DECK,nil,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end