--惧 轮  莽 汉
function c53701020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53701020.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53701020.condition)
	e2:SetOperation(c53701020.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53701020,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,53701020)
	e3:SetCondition(c53701020.thcon)
	e3:SetTarget(c53701020.thtg)
	e3:SetOperation(c53701020.thop)
	c:RegisterEffect(e3)
end
function c53701020.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c53701020.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c53701020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c53701020.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and c:IsAbleToHand()
end
function c53701020.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53701020.filter,1,nil,1-tp)
end
function c53701020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c53701020.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c53701020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=eg:Filter(c53701020.filter2,nil,e,1-tp)
	if sg:GetCount()>=0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
