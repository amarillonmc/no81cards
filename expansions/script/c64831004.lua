--终末兽 努克
function c64831004.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,64831004)
	e1:SetCondition(c64831004.jumpcon)
	e1:SetTarget(c64831004.jumptg)
	e1:SetOperation(c64831004.jumpop)
	c:RegisterEffect(e1)
	--spfromgrave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,64831005)
	e2:SetCost(c64831004.spcost)
	e2:SetTarget(c64831004.sptg)
	e2:SetOperation(c64831004.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(64831004,ACTIVITY_SPSUMMON,c64831004.counterfilter)
end
function c64831004.counterfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c64831004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(64831004,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c64831004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c64831004.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c64831004.spfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c64831004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c64831004.spfil(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c64831004.spfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c64831004.spfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function c64831004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 then
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
				local nseq=math.log(s,2)
				Duel.MoveSequence(tc,nseq)
			end
		end
	end
end

function c64831004.jumpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c64831004.jumpfil,tp,LOCATION_MZONE,0,nil)==0
end
function c64831004.jumpfil(c)
	return c:IsType(TYPE_MONSTER) and not (c:IsSetCard(0x5410) and c:IsFaceup()) and c:GetSequence()<=4
end
function c64831004.jumptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c64831004.jumpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and not Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end