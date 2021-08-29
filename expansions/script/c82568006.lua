--泰拉的遗蚀·REUNION
function c82568006.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c82568006.mtcon)
	e1:SetOperation(c82568006.mtop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568006,6))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,82568006)
	e2:SetCost(c82568006.spcost)
	e2:SetTarget(c82568006.sptg)
	e2:SetOperation(c82568006.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(82568006,ACTIVITY_SPSUMMON,c82568006.counterfilter)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568006,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c82568006.hncost)
	e3:SetTarget(c82568006.hntg)
	e3:SetOperation(c82568006.hnop)
	c:RegisterEffect(e3)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(82567785)
	c:RegisterEffect(e4)
end
c82568006.hnchecks=aux.CreateChecks(Card.IsType,{TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ})
function c82568006.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c82568006.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82568006.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c82568006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82568006,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82568006.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82568006.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) 
end
function c82568006.filter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsLevelBelow(6) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) 
end
function c82568006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c82568006.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c82568006.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568006.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	local tc=g:GetFirst()
	tc:CompleteProcedure()
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
	end
end
function c82568006.cfilter(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsSetCard(0x825)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c82568006.fusionfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x825)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c82568006.ritualfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c82568006.synchrofilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x825)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c82568006.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x825)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c82568006.hngoal(g,e,tp,c)
	local sg=Group.FromCards(c)
	sg:Merge(g)
	return Duel.IsExistingMatchingCard(c82568006.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function c82568006.hnfilter(c,e,tp,sg)
	return c:IsCode(82568007) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) 
		and (not sg or Duel.GetLocationCountFromEx(tp,tp,sg,c)>0)
end
function c82568006.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c82568006.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c82568006.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c82568006.fusionfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c82568006.ritualfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c82568006.synchrofilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(c82568006.xyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) 
		and mg:CheckSubGroupEach(c82568006.hnchecks,c82568006.hngoal,e,tp,c) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568006,1))
	local sg=Duel.SelectMatchingCard(tp,c82568006.fusionfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568006,2))
	local rg=Duel.SelectMatchingCard(tp,c82568006.ritualfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	sg:Merge(rg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568006,3))
	local syg=Duel.SelectMatchingCard(tp,c82568006.synchrofilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	sg:Merge(syg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568006,4))
	local xg=Duel.SelectMatchingCard(tp,c82568006.xyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	sg:Merge(xg)
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c82568006.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568006.hnop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568006,5))
	local g=Duel.SelectMatchingCard(tp,c82568006.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:AddCounter(0x5824,4)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82568006,7))
	 local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c82568006.atkcon)
	e2:SetCost(c82568006.atkcost)
	e2:SetOperation(c82568006.atkop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(82568006,8))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCost(c82568006.damcost)
	e1:SetTarget(c82568006.damtg)
	e1:SetOperation(c82568006.damop)
	tc:RegisterEffect(e1)
	end
end
function c82568006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local bc=tc:GetBattleTarget()
	return bc and bc:GetCounter(0x5823)>0 and bc:GetAttack()>0
end
function c82568006.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	if chk==0 then return tc:GetFlagEffect(82568006)==0 end
	tc:RegisterFlagEffect(82568006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c82568006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and tc:IsFaceup() and bc:IsRelateToBattle() 
		then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack()/2)
		bc:RegisterEffect(e1)
	end
end
function c82568006.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5824,1,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5824,1,REASON_COST)
end
function c82568006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c82568006.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
