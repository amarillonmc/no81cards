--小异梦书使-馆长女儿
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400042.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c71400042.atklimit)
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
	e2:SetCondition(c71400042.dircon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400042,0))
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c71400042.tg3)
	e3:SetOperation(c71400042.op3)
	e3:SetCondition(c71400042.con3)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
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
	e4:SetDescription(aux.Stringid(71400042,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCondition(c71400042.con4)
	e4:SetTarget(c71400042.tg4)
	e4:SetOperation(c71400042.op4)
	c:RegisterEffect(e4)
end
function c71400042.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c71400042.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c71400042.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c71400042.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c71400042.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c71400042.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c71400042.filter3(c)
	local flag=false
	if c:IsLocation(LOCATION_HAND) then flag=c:IsSetCard(0x714)
	else flag=c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) end
	return flag and c:IsAbleToRemoveAsCost()
end
function c71400042.xyzfilter(c,e,tp)
	return c:IsSetCard(0x3715) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71400042.linkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c71400042.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c71400042.linkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c71400042.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400042.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400042.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400042.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		sc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c71400042.filter4(c,e,tp)
	return c:IsCode(71400011) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c71400042.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsCode(71400026) and c:GetFlagEffect(1)>0
end
function c71400042.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,LOCATION_GRAVE) end
end
function c71400042.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400042.filter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)==1 then
		sc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(sc,c)
		end
	end
end