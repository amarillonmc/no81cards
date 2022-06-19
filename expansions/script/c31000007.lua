--Fallacio Swanbird
function c31000007.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,31000007)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31000007.spcon)
	e1:SetTarget(c31000007.sptg)
	e1:SetOperation(c31000007.spop)
	c:RegisterEffect(e1)
	--Gain Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,31000008)
	e2:SetTarget(c31000007.target)
	e2:SetOperation(c31000007.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCountLimit(1)
	e5:SetCondition(c31000007.sycon)
	c:RegisterEffect(e5)
end

function c31000007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local spfilter=function(c)
		return c:IsCode(31000002) and c:IsLevel(e:GetHandler():GetLevel())
	end
	return Duel.IsExistingMatchingCard(spfilter,tp,nil,LOCATION_MZONE,1,nil)
end

function c31000007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c31000007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c31000007.spfilter(c)
	return c:IsSetCard(0x308)
end

function c31000007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c31000003.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31000007.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c31000007.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c31000007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		local con=function(e,tp,eg,ep,ev,re,r,rp)
			local rc=e:GetHandler():GetReasonCard()
			return r==REASON_SYNCHRO and rc:IsSetCard(0x308)
		end
		local op=function(e,tp,eg,ep,ev,re,r,rp)
			local rc=e:GetHandler():GetReasonCard()
			local code=e:GetHandler():GetCode()
			rc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BE_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
		e1:SetCondition(con)
		e1:SetOperation(op)
		c:RegisterEffect(e1)
	end
end

function c31000007.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SYNCHRO)
end
