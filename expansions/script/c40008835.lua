--云魔物-狂风暴龙
function c40008835.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c40008835.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0x18),1,99)
	c:EnableReviveLimit()   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008835,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40008835)
	e1:SetCondition(c40008835.thcon)
	e1:SetTarget(c40008835.thtg)
	e1:SetOperation(c40008835.thop)
	c:RegisterEffect(e1) 
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008835,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c40008835.ctcon)
	e2:SetTarget(c40008835.cttg)
	e2:SetOperation(c40008835.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c40008835.sdcon)
	c:RegisterEffect(e7)
end
function c40008835.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsCode(80825553)
end
function c40008835.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40008835.thfilter(c)
	return (c:IsSetCard(0x18) or aux.IsCounterAdded(c,0x1019)) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c40008835.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008835.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c40008835.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008835,3))
	local g=Duel.SelectMatchingCard(tp,c40008835.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c40008835.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x18) and c:IsControler(tp)
end
function c40008835.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40008835.ctfilter,1,nil,tp)
end
function c40008835.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1019,1) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1019,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,LOCATION_MZONE)
end
function c40008835.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1019,1)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   g:GetFirst():AddCounter(0x1019,1)
	end
end
function c40008835.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end