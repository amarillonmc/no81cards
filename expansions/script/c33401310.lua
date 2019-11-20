--五河士道 结缘
function c33401310.initial_effect(c)
	 --NTR
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401310,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33401310)
	e1:SetTarget(c33401310.target)
	e1:SetOperation(c33401310.activate)
	c:RegisterEffect(e1)
 --th
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401310,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33401310)
	e2:SetCondition(c33401310.thcon)
	e2:SetTarget(c33401310.thtg)
	e2:SetOperation(c33401310.thop)
	c:RegisterEffect(e2)
end
function c33401310.filter(c)
	return  c:IsSetCard(0x341) and c:IsControlerCanBeChanged()
end
function c33401310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(c33401310.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c33401310.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c33401310.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.GetControl(tc,tp)  
	end
end

function c33401310.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0x341) or rc:IsSetCard(0xa342) and r&REASON_FUSION+REASON_LINK~=0
end
function c33401310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
end
function c33401310.thfilter(c)
	return  c:IsType(TYPE_MONSTER)and (c:IsSetCard(0x341) or c:IsSetCard(0xa342)) and c:IsAbleToHand() and not c:IsSetCard(0xc342) 
end
function c33401310.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33401310.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
