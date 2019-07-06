--GUARDIAN 灯花
function c33700046.initial_effect(c)
	  --summon without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700046,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c33700046.ntcon)
	c:RegisterEffect(e1)
	 --remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700046,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c33700046.rmcost)
	e3:SetTarget(c33700046.rmtg)
	e3:SetOperation(c33700046.rmop)
	c:RegisterEffect(e3)
end
function c33700046.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetMZoneCount(c:GetControler())>0
		and Duel.GetCounter(c:GetControler(),LOCATION_ONFIELD,0,0x1021)>0
end
function c33700046.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1021,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1021,2,REASON_COST)
end
function c33700046.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c33700046.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end