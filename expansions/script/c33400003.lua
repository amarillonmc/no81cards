--时崎狂三---献身者
function c33400003.initial_effect(c)
	 c:EnableCounterPermit(0x34f)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c33400003.addct)
	e1:SetOperation(c33400003.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	 --destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c33400003.reptg)
	e3:SetValue(c33400003.repval)
	e3:SetOperation(c33400003.repop)
	c:RegisterEffect(e3)
	--SPECIAL_SUMMON
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,33400003)
	e4:SetCondition(c33400003.con4)
	e4:SetTarget(c33400003.target4)
	e4:SetOperation(c33400003.operation4)
	c:RegisterEffect(e4)
	 local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,33400003)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c33400003.con5)
	e5:SetTarget(c33400003.target4)
	e5:SetOperation(c33400003.operation4)
	c:RegisterEffect(e5)
end
--e5
function c33400003.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re then return end
	if r&REASON_LINK~=0 or c:IsReason(REASON_BATTLE)  or c:IsReason(REASON_MATERIAL) then return end 
	return  re:GetOwner():IsSetCard(0x3341) or re:GetOwner():IsSetCard(0x3340)  
end
--e4
function c33400003.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0x3341) and r&REASON_LINK~=0
end
function c33400003.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33400003.operation4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--e3
function c33400003.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c33400003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c33400003.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c33400003.repval(e,c)
	return c33400003.repfilter(c,e:GetHandlerPlayer())
end
function c33400003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--e1
function c33400003.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x34f)
end
function c33400003.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,2)
	end
end