--智天之城 盖伊诺尔
function c67200093.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c67200093.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),true)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c67200093.tg)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c67200093.aclimit)
	c:RegisterEffect(e2)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200093,0))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1)
	e4:SetTarget(c67200093.mvtg)
	e4:SetOperation(c67200093.seqop)
	c:RegisterEffect(e4)
end
function c67200093.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x673)
end 
function c67200093.ffilter(c)
	return c:IsSetCard(0x673) and c:IsFusionType(TYPE_FUSION)
end
--cannot activate
function c67200093.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetColumnGroup():IsContains(tc)
end
--move
function c67200093.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c67200093.seqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(e:GetHandler(),nseq)~=0 then
	end
end
