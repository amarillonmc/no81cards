--虚拟主播 有栖Mana
function c33701322.initial_effect(c)
	c:SetUniqueOnField(1,0,33701322)  
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(c33701322.spop)
	c:RegisterEffect(e1)
	--SpecialSummon tp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c33701322.bspop)
	c:RegisterEffect(e2)
	--SpecialSummon 1-tp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c33701322.bspop1)
	c:RegisterEffect(e2)
end
function c33701322.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)/2)
end
function c33701322.bspop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.CheckLPCost(tp,1000) and Duel.GetTurnPlayer()==tp and e:GetHandler():IsReason(REASON_BATTLE) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
   Duel.PayLPCost(tp,1000)
   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
   end
end
function c33701322.bspop1(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetTurnPlayer()==tp then return end
   local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(33701322,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1,33701322)
		e1:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
		e1:SetTarget(c33701322.sptgx)
		e1:SetOperation(c33701322.spopx)
		c:RegisterEffect(e1)
end
function c33701322.sptgx(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c33701322.spopx(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	e:Reset()
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP) then
	Duel.Recover(tp,2100,REASON_EFFECT)
	end
end





