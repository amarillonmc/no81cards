--AK-辉煌的异客
function c82568066.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c82568066.tunerfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,82568066)
	e1:SetCondition(c82568066.ctcon)
	e1:SetTarget(c82568066.cttarget)
	e1:SetOperation(c82568066.ctoperation)
	c:RegisterEffect(e1)
	--Cage Summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCountLimit(1,82568166)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e4:SetTarget(c82568066.dtg)
	e4:SetCost(c82568066.dcost)
	e4:SetOperation(c82568066.dop)
	c:RegisterEffect(e4)
end
function c82568066.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568066.dfilter(c)
	return c:IsFaceup() and c:GetCounter(0x5825)>0 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c82568066.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568066.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c82568066.dfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c82568066.tgfilter2(c,s)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
	
end
function c82568066.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c82568066.dfilter,tp,0,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e)  then
		local g=Duel.GetMatchingGroup(c82568066.dfilter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		while tc do
		 local seq=tc:GetSequence()
		 local dg=Group.CreateGroup()
		 if seq<5 then dg=Duel.GetMatchingGroup(c82568066.tgfilter2,tp,0,LOCATION_ONFIELD,nil,seq) end
		 if dg:GetCount()>0 then
		 g:Merge(dg)
		 tc=g:GetNext()
		 end
		end
		local tc2=g:GetFirst()
		while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2)
		tc2=g:GetNext()
		end
		local dmg=Duel.GetCounter(tp,0,LOCATION_ONFIELD,0x5825)*300
		Duel.Damage(1-tp,dmg,REASON_EFFECT)
   end
end
function c82568066.tunerfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) 
end 
function c82568066.ctfilter(c)
	return c:IsFaceup() 
end
function c82568066.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function c82568066.cttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568066.ctfilter,tp,0,LOCATION_ONFIELD,1,nil) and c:GetMaterial():GetCount()>0 end
	local sg=c:GetMaterial()
	local sml=sg:GetMinGroup(Card.GetLevel)
	local sml1=sml:GetFirst()
	local smlv=sml1:GetLevel()
	e:SetLabel(smlv)
end
function c82568066.ctoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local smlv=e:GetLabel()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c82568066.ctfilter,tp,0,LOCATION_ONFIELD,1,smlv,nil)
	local tc=g:GetFirst()
	while tc  do	
	  tc:AddCounter(0x5825,1)
	 tc=g:GetNext()
	end
end
