--影紫炎的霞城
function c98920578.initial_effect(c)
	c:EnableCounterPermit(0x3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c98920578.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c98920578.atktg)
	e4:SetValue(c98920578.atkval)
	c:RegisterEffect(e4)
	--no summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920578,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(2,98920578)
	e2:SetCost(c98920578.spcost)
	e2:SetTarget(c98920578.sptg)
	e2:SetOperation(c98920578.spop)
	c:RegisterEffect(e2)
end
function c98920578.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d)
end
function c98920578.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c98920578.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x3,1)
	end
end
function c98920578.atktg(e,c)
	return c:IsSetCard(0x20,0x3d)
end
function c98920578.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x3)*100
end
function c98920578.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x3,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x3,2,REASON_COST)
end
function c98920578.atkfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsSetCard(0x3d)
end
function c98920578.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920578.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920578.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920578.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c98920578.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local flag=0
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
	local flag=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetLabel(flag)
	e1:SetTarget(c98920578.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98920578.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(flag)
end