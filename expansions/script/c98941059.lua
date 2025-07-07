--魊影的恐惧 羽
local s,id,o=GetID()
function c98941059.initial_effect(c)
	--小鱼
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98941059,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98941059.con)
	e0:SetTarget(c98941059.tg)
	e0:SetOperation(c98941059.op)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_MZONE)
	e33:SetTargetRange(LOCATION_EXTRA,0)
	e33:SetTarget(c98941059.eftg1)
	e33:SetLabelObject(e0)
	c:RegisterEffect(e33)
	--大蛇
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(98941059,3))
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_EXTRA)
	e10:SetCondition(c98941059.con1)
	e10:SetTarget(c98941059.tg1)
	e10:SetOperation(c98941059.op1)
	e10:SetValue(SUMMON_TYPE_SYNCHRO)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e30:SetRange(LOCATION_MZONE)
	e30:SetTargetRange(LOCATION_EXTRA,0)
	e30:SetTarget(c98941059.eftg2)
	e30:SetLabelObject(e10)
	c:RegisterEffect(e30)
	--spsummon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941059,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98942059)
	e2:SetTarget(c98941059.thtg)
	e2:SetOperation(c98941059.thop)
	c:RegisterEffect(e2)
end
function c98941059.synfilter(c)
	return c:IsRace(RACE_FISH) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToRemove()
end
function c98941059.con(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if Duel.GetFlagEffect(tp,98941059)~=0 then return false end
	local mg=Duel.GetMatchingGroup(c98941059.synfilter,c:GetControler(),LOCATION_DECK+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) and smat:IsRace(RACE_FISH) then
		return Duel.CheckTunerMaterial(c,smat,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),aux.NonTuner(Card.IsRace,RACE_FISH),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),aux.NonTuner(Card.IsRace,RACE_FISH),1,99,smat,mg)
end
function c98941059.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=nil
	local mg=Duel.GetMatchingGroup(c98941059.synfilter,c:GetControler(),LOCATION_DECK+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) and smat:IsSetCard(0x35) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),aux.NonTuner(Card.IsRace,RACE_FISH),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),aux.NonTuner(Card.IsRace,RACE_FISH),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c98941059.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local g1=g:Clone()
	g1:Sub(g2)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Remove(g2,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.RegisterFlagEffect(tp,98941059,RESET_PHASE+PHASE_END,0,1)
	g:DeleteGroup()
	g1:DeleteGroup()
	g2:DeleteGroup()
end
function c98941059.eftg1(e,c)
	return c:IsSetCard(0x18a) and not c:IsCode(72309040)
end
function c98941059.synfilter1(c)
	return c:IsRace(RACE_FISH) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToRemove()
end
function c98941059.con1(e,c,smat)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if Duel.GetFlagEffect(tp,98941059)~=0 then return false end
	local g=Duel.GetMatchingGroup(c98941059.synfilter1,c:GetControler(),LOCATION_DECK+LOCATION_MZONE,0,nil)
	aux.GCheckAdditional=c98941059.hspgcheck
	local res=g:CheckSubGroup(c98941059.hspcheck,2,#g)
	aux.GCheckAdditional=nil
	return res
end
function c98941059.hspgcheck(g)
	--Duel.SetSelectedCard(g)
	return g:GetSum(Card.GetLevel)<=10
end
function c98941059.hspcheck(g)
	--Duel.SetSelectedCard(g)
	return g:GetSum(Card.GetLevel)==10 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(c98941059.notunerfilter,1,nil) 
end
function c98941059.notunerfilter(c)
	return not c:IsType(TYPE_TUNER)
end
function c98941059.tg1(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=Duel.GetMatchingGroup(c98941059.synfilter1,c:GetControler(),LOCATION_DECK+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=c98941059.hspgcheck
	local g=mg:SelectSubGroup(tp,c98941059.hspcheck,false,2,#mg)
	aux.GCheckAdditional=nil
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c98941059.op1(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local g1=g:Clone()
	g1:Sub(g2)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Remove(g2,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.RegisterFlagEffect(tp,98941059,RESET_PHASE+PHASE_END,0,1)
	g:DeleteGroup()
	g1:DeleteGroup()
	g2:DeleteGroup()
end
function c98941059.eftg2(e,c)
	return c:IsCode(72309040)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.costfilter(c)
	return c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost() and not c:IsCode(98941059)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98941059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98941059.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end