--闪刀姬-地鸣
function c75147502.initial_effect(c)
	c:SetSPSummonOnce(75147502)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c75147502.matfilter,2,2)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75147502,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c75147502.target)
	e2:SetOperation(c75147502.activate)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75147502,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c75147502.spcon)
	e3:SetTarget(c75147502.sptg)
	e3:SetOperation(c75147502.spop)
	c:RegisterEffect(e3)
end
function c75147502.matfilter(c)
	return c:IsLinkSetCard(0x1115) and not c:IsLinkAttribute(ATTRIBUTE_EARTH)
end
function c75147502.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c75147502.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c75147502.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		local b1=Duel.IsExistingMatchingCard(c75147502.seqfilter,tc:GetControler(),LOCATION_MZONE,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c75147502.seqfilter,1-tc:GetControler(),LOCATION_MZONE,0,2,nil)
		local b3=Duel.IsExistingMatchingCard(c75147502.seqfilter,1-tc:GetControler(),LOCATION_MZONE,0,1,nil)
		if tc:GetSequence()<5 and not b1 and not b2 and Duel.SelectYesNo(tp,aux.Stringid(75147502,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=0
			if b3 then
				local seq=Duel.GetMatchingGroup(c75147502.seqfilter,1-tc:GetControler(),LOCATION_MZONE,0,nil):GetFirst():GetSequence()
				if (1-tc:GetControler()==tp and seq==6) or 
				   (1-tc:GetControler()~=tp and seq==5) then
					s=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~0x400020)
				else
					s=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~0x200040)
				end
			else
				s=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~0x600060)
			end
			if bit.band(s,0x400020)>0 then
				if tc:GetControler()~=tp then
					Duel.MoveSequence(tc,6)
				else
					Duel.MoveSequence(tc,5)
				end
			elseif bit.band(s,0x200040)>0 then
				if tc:GetControler()~=tp then
					Duel.MoveSequence(tc,5)
				else
					Duel.MoveSequence(tc,6)
				end
			end
		end
	end
end
function c75147502.seqfilter(c)
	return c:GetSequence()>4
end

function c75147502.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c75147502.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c75147502.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c75147502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75147502.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75147502.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75147502.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP,0x60)
		end
	end
end