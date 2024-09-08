--闪光泡泡
function c33718016.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_SSET,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e0)
--自己场上的水族怪兽被战斗破坏的场合必定发动。这张卡的2效果直到下次自己的准备阶段无效。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33718016,0))
	e1:SetCategory(CATEGORY_DISABLE+)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c33718016.condition)
	e1:SetTarget(c33718016.target)
	e1:SetOperation(c33718016.operation)
	c:RegisterEffect(e1)
--「水族馆」卡在场上存在的场合，场上的水族怪兽以外的怪兽的效果无效化。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c33718016.limitcondition)
	e2:SetTarget(c33718016.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
--这张卡从场上送入墓地的场合，可以以自己墓地的1只水族怪兽为对象发动。将那只怪兽特殊召唤。
--这个效果发动后，直到回合结束时自己特殊召唤的只能是水族怪兽。
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c33718016.spcondition)
	e3:SetTarget(c33718016.sptarget)
	e3:SetOperation(c33718016.spoperation)
	c:RegisterEffect(e3)
end
function c33718016.filter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsRace(RACE_AQUA) and c:IsControler(tp)
end
function c33718016.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33718016.filter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c33718016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,e:GetHandler(),1,0,0)
end
function c33718016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,1)
		end
		c:RegisterEffect(e1)
	end
end

function c33718016.limitfilter(c)
	return c:IsSetCard(0xce) and c:IsFaceup()
end
function c33718016.limitcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33718016.limitfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c33718016.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0 and not c:IsRace(RACE_AQUA)
end
function c33718016.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33718016.spfilter(c,e,tp)
	return c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718016.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33718016.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33718016.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33718016.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33718016.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33718016.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33718016.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_AQUA
end
