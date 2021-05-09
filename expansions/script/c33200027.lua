--奇谋善阵 张俊乂
function c33200027.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsRace,RACE_WARRIOR),aux.NonTuner(nil),nil,aux.NonTuner(c33200027.sfilter),1,1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c33200027.disop)
	c:RegisterEffect(e1)
	--qiao bian
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200027,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,33200027)
	e4:SetCondition(c33200027.con)
	e4:SetTarget(c33200027.sptg)
	e4:SetOperation(c33200027.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33200027,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,33200028)
	e5:SetCondition(c33200027.con)
	e5:SetTarget(c33200027.settg)
	e5:SetOperation(c33200027.setop)
	c:RegisterEffect(e5)
end

c33200027.material_type=TYPE_SYNCHRO
function c33200027.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end

--e1
function c33200027.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(loc,re:GetHandler():GetLocation())==0 and re:GetHandler():GetControler()==1-tp then
		Duel.NegateEffect(ev)
	end
end

--con
function c33200027.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

--e4
function c33200027.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsLocation(LOCATION_FZONE)
end
function c33200027.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c33200027.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200027.filter1,tp,0,LOCATION_SZONE,1,nil) 
	and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33200027.filter1,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33200027.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+RESET_TOHAND+RESET_TOGRAVE+RESET_TODECK+RESET_REMOVE)
		tc:RegisterEffect(e1,true)  
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_WARRIOR)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_WATER)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(1)
		tc:RegisterEffect(e6,true)
		Duel.SpecialSummonStep(tc,0,tp,1-tp,true,false,POS_FACEUP_DEFENSE)  
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7,true)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e8,true)
		local e9=e7:Clone()
		e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e9,true) 
		local e10=e7:Clone()
		e10:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e10,true)
		local e11=e7:Clone()
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e11,true) 
		local e12=e7:Clone()
		e12:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		tc:RegisterEffect(e12,true) 
		Duel.SpecialSummonComplete()
	end
end

--e5
function c33200027.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33200027.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c33200027.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200027.filter2,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200027.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c33200027.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)<=0 then return end
	Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
end