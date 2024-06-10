--云上的碧阁
function c67200772.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200772,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,67200773)
	e1:SetCondition(c67200772.otcon)
	e1:SetTarget(c67200772.ottg)
	e1:SetOperation(c67200772.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,67200772)
	e3:SetCondition(c67200772.setcon)
	e3:SetTarget(c67200772.settg)
	e3:SetOperation(c67200772.setop)
	c:RegisterEffect(e3)	 
end
--
function c67200772.otfilter(c,e,tp)
	return c:IsAbleToHand() and not c:IsImmuneToEffect(e) and c:IsSetCard(0x967b)
end
function c67200772.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.IsExistingMatchingCard(c67200772.otfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp)
end
function c67200772.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return c:IsSetCard(0x967b)
end
function c67200772.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,c67200772.otfilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	c:SetMaterial(nil)
end
--
function c67200772.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function c67200772.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c67200772.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
