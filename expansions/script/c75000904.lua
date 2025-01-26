--卓越的战术师 鲁弗莱
function c75000904.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75000904,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e0) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75000904.target)
	e1:SetOperation(c75000904.activate)
	c:RegisterEffect(e1)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000904,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,75000904)
	e3:SetCondition(c75000904.spcon)
	e3:SetTarget(c75000904.sptg)
	e3:SetOperation(c75000904.spop)
	c:RegisterEffect(e3)	  
end
function c75000904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75000904,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000904.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75000904,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
--
function c75000904.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSSetable()
end
function c75000904.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75000904,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c75000904.thfilter(c)
	return c:IsCode(75000903) and c:IsAbleToHand()
end
function c75000904.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75000904,0,TYPES_EFFECT_TRAP_MONSTER,1900,0,6,RACE_DRAGON,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 and  hg:GetCount()>0 then
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=hg:RandomSelect(1-tp,1)
		local tc=sg:GetFirst()
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
		--local c=e:GetHandler()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c75000904.retcon)
		e1:SetOperation(c75000904.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(75000904,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end
function c75000904.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75000904)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75000904.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
