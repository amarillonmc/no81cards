--终末之机械骑士
function c98920114.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--search
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98920114,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetCountLimit(1,98920114)
	e11:SetTarget(c98920114.tg)
	e11:SetOperation(c98920114.op)
	c:RegisterEffect(e11)
	local e2=e11:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920114,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98930114)
	e1:SetLabelObject(e0)
	e1:SetCondition(c98920114.spcon)
	e1:SetTarget(c98920114.sptg)
	e1:SetOperation(c98920114.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c98920114.filter(c)
	return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920114) and c:IsAbleToHand()
end
function c98920114.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920114.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920114.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920114.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920114.cfilter(c,tp,se,r)
	local ref=c:GetReasonEffect()
	return c:IsFaceup() and c:IsSetCard(0x10c) and c:IsControler(tp) and (se==nil or c:GetReasonEffect()~=se) and not c:IsType(TYPE_LINK) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_SYNCHRO) and ref and ref:GetCode()==EFFECT_SPSUMMON_PROC 
end
function c98920114.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()	   
	return eg:IsExists(c98920114.cfilter,1,nil,tp,se)
end
function c98920114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920114.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c98920114.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c98920114.splimit(e,c)
	return not c:IsSetCard(0x10c)
end