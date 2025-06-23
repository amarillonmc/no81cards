--楚楚可怜的公主与忠诚的骑士
function c22023600.initial_effect(c)
	aux.AddCodeList(c,22023580)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023600+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c22023600.xatkcon)
	e1:SetTarget(c22023600.target)
	e1:SetOperation(c22023600.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c22023600.reptg)
	e2:SetValue(c22023600.repval)
	e2:SetOperation(c22023600.repop)
	c:RegisterEffect(e2)
end
function c2801664.xatkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function c22023600.spfilter3(c,e,tp)
	return c:IsCode(22023580) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22023600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023600.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22023600.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c22023600.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22023600.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c22023600.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c22023600.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c22023600.repval(e,c)
	return c22023600.repfilter(c,e:GetHandlerPlayer())
end
function c22023600.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
