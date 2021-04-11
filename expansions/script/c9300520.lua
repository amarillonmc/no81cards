--替身使者-提查诺
function c9300520.initial_effect(c)
	aux.AddCodeList(c,9300519)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9300520+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9300520.sprcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9300520,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9300520.spcost)
	e2:SetOperation(c9300520.indop)
	c:RegisterEffect(e2)
   --to hand/spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9301520)
	e3:SetCondition(c9300520.recon)
	e3:SetTarget(c9300520.regtg)
	e3:SetOperation(c9300520.regop)
	c:RegisterEffect(e3)
	--attack target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e4:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--Announce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e5:SetCondition(c9300520.condition)
	e5:SetOperation(c9300520.operation)
	c:RegisterEffect(e5)
end
function c9300520.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1f99) and c:GetCode()~=9300520
end
function c9300520.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9300520.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9300520.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9300520.indop(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCountLimit(1)
		e1:SetTarget(c9300520.immtg)
		e1:SetValue(c9300520.valcon)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c9300520.immtg)
		e2:SetValue(c9300520.tgoval)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e2,tp)
end
function c9300520.immtg(e,c)
	return c:IsCode(9300519)
end
function c9300520.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c9300520.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9300520.thfilter(c)
	return c:IsLevelBelow(6) and c:IsSetCard(0x1f99) and c:IsType(TYPE_MONSTER) and c:GetCode()~=9300520 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9300520.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9300520.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9300520.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9300520.thcon)
	e1:SetOperation(c9300520.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9300520.thfilter2(c)
	return c9300520.thfilter(c) and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9300520.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9300520.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c9300520.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_CARD,0,9300520)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c9300520.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if tc:GetLeftScale()==5 and res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c9300520.condition(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c9300520.chlimit)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return rp==1-tp and ex  
end
function c9300520.chlimit(e,ep,tp)
	return tp==ep
end
function c9300520.operation(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	local ac=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	if re:GetHandler().announce_filter==nil then
		--not c:IsCode(code)
		ac=Duel.AnnounceCard(tp,code,OPCODE_ISCODE,OPCODE_NOT)
	else
		local afilter={table.unpack(re:GetHandler().announce_filter)}
		--and not c:IsCode(code)
		table.insert(afilter,code)
		table.insert(afilter,OPCODE_ISCODE)
		table.insert(afilter,OPCODE_NOT)
		table.insert(afilter,OPCODE_AND)
		ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	end
	Duel.ChangeTargetParam(ev,ac)
end