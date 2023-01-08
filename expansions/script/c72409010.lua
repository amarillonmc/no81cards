--神造遗物使 天
function c72409010.initial_effect(c)
	aux.AddCodeList(c,72409060)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72409010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72409010)
	e1:SetTarget(c72409010.thtg)
	e1:SetOperation(c72409010.thop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72409010.atkcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)   
end
function c72409010.thfilter(c)
	return c:IsSetCard(0xe729) and not c:IsCode(72409010) and c:IsAbleToHand()
end
function c72409010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72409010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72409010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72409010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c72409010.atkfilter(c,e)
	return c:IsFaceup() and c:IsCode(72409060) and Card.GetEquipTarget(c)==e:GetHandler()
end
function c72409010.atkcon(e)
	local hc=e:GetHandler()
	return Duel.IsExistingMatchingCard(c72409010.atkfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e)
end
