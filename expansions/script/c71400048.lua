--黑白的异梦小少女 Monoko
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400048.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c71400048.atklimit)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c71400048.dircon)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(4)
	c:RegisterEffect(e3)
	--transform
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4a:SetCode(EVENT_CHAINING)
	e4a:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4a:SetOperation(aux.chainreg)
	c:RegisterEffect(e4a)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71400048,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c71400048.con4)
	e4:SetTarget(c71400048.tg4)
	e4:SetOperation(c71400048.op4)
	c:RegisterEffect(e4)
	--transform
	local e4b=Effect.CreateEffect(c)
	e4b:SetDescription(aux.Stringid(71400048,0))
	e4b:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4b:SetCountLimit(1)
	e4b:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4b:SetRange(LOCATION_MZONE)
	e4b:SetCondition(c71400048.con4b)
	e4b:SetTarget(c71400048.tg4)
	e4b:SetOperation(c71400048.op4)
	c:RegisterEffect(e4b)
	Duel.AddCustomActivityCounter(71400048,ACTIVITY_CHAIN,c71400048.chainfilter)
end
function c71400048.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c71400048.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c71400048.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c71400048.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c71400048.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c71400048.filter4(c,e,tp)
	return c:IsCode(71400045) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c71400048.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsCode(71400047) and c:GetFlagEffect(1)>0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c71400048.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400048.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(71400047) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c71400048.con4b(e)
	return Duel.GetCustomActivityCount(71400048,e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function c71400048.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCountFromEx(tp,tp,c)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400048.filter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end