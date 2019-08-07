--救世的闪珖
function c10150080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150080,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10150080.spcost)
	e2:SetTarget(c10150080.sptg)
	e2:SetOperation(c10150080.spop)
	c:RegisterEffect(e2)  
	--sp 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51858200,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10150080.sptg2)
	e3:SetOperation(c10150080.spop2)
	c:RegisterEffect(e3)  
end
c10150080.list={[44508094]=7841112,[70902743]=67030233,[9012916]=10150083,[2403771]=10150078,[73580471]=10150077,[25862681]=10150079}
function c10150080.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c10150080.cfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c10150080.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10150080.filter3(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsSetCard(0x3f) and c:IsType(TYPE_SYNCHRO) and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c10150080.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c10150080.spcon3)
	e1:SetOperation(c10150080.spop3)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	   e1:SetValue(Duel.GetTurnCount())
	   e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
	   e1:SetValue(0)
	   e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e:GetLabelObject())
end
function c10150080.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetValue()
end
function c10150080.spop3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.IsExistingMatchingCard(c10150080.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) and Duel.GetLocationCountFromEx(tp)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
	   Duel.Hint(HINT_CARD,0,10150080)
	   local tc=Duel.SelectMatchingCard(tp,c10150080.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst()
	   if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		  tc:CompleteProcedure()
	   end
	end
end
function c10150080.cfilter(c,tp)
	return c:IsSetCard(0x3f) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x3f) and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousTypeOnField(),TYPE_SYNCHRO)~=0 and c:IsType(TYPE_SYNCHRO)
end
function c10150080.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10150080.filter1(c,e,tp)
	local code=c:GetCode()
	local tcode=c10150080.list[code]
	return tcode and Duel.IsExistingMatchingCard(c10150080.filter2,tp,LOCATION_EXTRA,0,1,nil,tcode,e,tp) and not c:IsCode(21159309) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c10150080.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c10150080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and Duel.CheckReleaseGroup(tp,c10150080.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c10150080.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10150080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	local code=e:GetLabel()
	local tcode=c10150080.list[code]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10150080.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tcode,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
	   tc:CompleteProcedure()
	end
end
