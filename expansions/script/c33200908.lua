--寒霜灵兽 刺甲贝
function c33200908.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200908)
	e1:SetCost(c33200908.spcost)
	e1:SetTarget(c33200908.sptg)
	e1:SetOperation(c33200908.spop)
	c:RegisterEffect(e1) 
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33200908,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,33210908)
	e0:SetTarget(c33200908.pctg)
	e0:SetOperation(c33200908.pcop)
	c:RegisterEffect(e0)
	local e3=e0:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200908,1))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c33200908.cttg)
	e2:SetOperation(c33200908.ctop)
	c:RegisterEffect(e2)   
end
c33200908.toss_dice=true

--e1
function c33200908.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200908.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200908.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200908.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33200908.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c33200908.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200908.ctfilter,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(33200908)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200908.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	e:GetHandler():RegisterFlagEffect(33200908,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,tc,nil,0,0x132a)
	if e:GetHandler():IsLocation(LOCATION_HAND) then 
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),nil,0,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_MZONE) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),nil,0,LOCATION_MZONE)
	end
end
function c33200908.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ctc=0
	local dtc=99
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.GetFlagEffect(tp,33200900)>0 then
			ctc=6
		else
			ctc=Duel.TossDice(tp,1)
		end
		if ctc>0 then 
			tc:AddCounter(0x132a,ctc)
			if tc:IsType(TYPE_LINK) then 
				dtc=tc:GetLink()
			elseif tc:IsType(TYPE_XYZ) then 
				dtc=tc:GetRank()
			else
				dtc=tc:GetLevel()
			end
			ctc=tc:GetCounter(0x132a)
			if dtc<ctc then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
		Duel.BreakEffect()
		if e:GetHandler():IsLocation(LOCATION_ONFIELD) then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		elseif e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra() then 
			Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
		end
	end
end

--e3
function c33200908.pcfilter(c)
	return c:IsSetCard(0x332a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c33200908.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c33200908.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c33200908.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c33200908.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end