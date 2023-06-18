--放光水晶机巧-中枢大蛇
function c88100003.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(nil),nil,nil,aux.Tuner(nil),2,99)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100003,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c88100003.rmcon)
	e1:SetTarget(c88100003.rmtg)
	e1:SetOperation(c88100003.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,88100003)
	e2:SetCondition(c88100003.spcon)
	e2:SetTarget(c88100003.sptg)
	e2:SetOperation(c88100003.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1,88200003)
	e3:SetTarget(c88100003.thtg)
	e3:SetOperation(c88100003.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c88100003.aclimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(21142671)
	c:RegisterEffect(e5)
end
function c88100003.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c88100003.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c88100003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetMaterialCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(1-tp) and c88100003.rmfilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c88100003.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,nil,1-tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c88100003.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88100003.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c88100003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c88100003.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88100003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c88100003.spfilter(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88100003.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88100003.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88100003.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c88100003.thfilter(c)
	return c:IsSetCard(0x30ea) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c88100003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88100003.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88100003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,c88100003.thfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c88100003.acfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c88100003.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c88100003.acfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,1,nil,re:GetHandler():GetCode())
end