--黑白异梦少女-黑白子
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400045.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,yume.YumeCheck(c,true),aux.NonTuner(nil),1)
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400045,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,71400045)
	e1:SetCondition(c71400045.con1)
	e1:SetTarget(c71400045.tg1)
	e1:SetOperation(c71400045.op1)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c71400045.val)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(4)
	e3:SetCondition(c71400045.con3)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(71400045,ACTIVITY_CHAIN,c71400045.chainfilter)
	--pos
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(71400045,1))
	e3a:SetCategory(CATEGORY_POSITION)
	e3a:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3a:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetCountLimit(1)
	e3a:SetCondition(c71400045.con3a)
	e3a:SetOperation(c71400045.op3a)
	c:RegisterEffect(e3a)
end
function c71400045.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c71400045.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c71400045.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400045.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c71400045.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400045.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
--[[
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71400045.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
--]]
end
function c71400045.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x714))
end
function c71400045.val(e,c)
	return Duel.GetMatchingGroupCount(c71400045.filter2,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*100
end
function c71400045.filter2(c)
	return c:IsSetCard(0x714) and (c:IsType(TYPE_TUNER) or c:IsType(TYPE_SYNCHRO)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c71400045.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(71400047) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c71400045.con3(e)
	return Duel.GetCustomActivityCount(71400045,e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function c71400045.con3a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c71400045.con2(e) and c:IsAttackPos() and c:GetBattledGroupCount()>0
end
function c71400045.op3a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end