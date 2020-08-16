--超科学星人 黑暗巴尔坦
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000080)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon)
	local e1=rsef.QO(c,nil,{m,0},nil,"tk,sp","cd,cn",LOCATION_MZONE,rscon.phmp,nil,cm.tktg,cm.tkop)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,1},nil,"neg,rm","dsp,dcal,cd,cn",LOCATION_MZONE,cm.negcon,nil,cm.negtg,rsop.negop("rm"))
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,2},nil,"rm","de,dsp,cd,cn",LOCATION_MZONE,rscon.phmp,nil,cm.rmtg,cm.rmop)
	local e4=rsef.QO(c,nil,{m,3},nil,"rm","cd,cn",LOCATION_MZONE,rscon.phmp,nil,cm.rmtg2,cm.rmop2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e5:SetCondition(cm.acon)
	e5:SetValue(cm.aval)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_SET_BATTLE_DEFENSE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.acon)
	e6:SetValue(cm.dval)
	c:RegisterEffect(e6)
end
function cm.spcon(e,c,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,1800,1800,4,RACE_INSECT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,1800,1800,4,RACE_INSECT,ATTRIBUTE_DARK) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local spct=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or ft
	for i=1,ft do 
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=rsef.SV_CHANGE({c,token},"type",TYPE_EFFECT+TYPE_MONSTER,nil,rsreset.est)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(m)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		token:CopyEffect(m,RESET_EVENT+RESETS_STANDARD,1)
	end
	Duel.SpecialSummonComplete()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp and c:GetFlagEffect(m)<Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsCode,m),tp,LOCATION_ONFIELD,0,nil) and rscon.phmp(e,tp)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
end
function cm.rmfilter(c,tp)
	return c:IsAbleToRemove() and c:GetSummonPlayer()~=tp
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()  
	local rg=eg:Filter(cm.rmfilter,nil,tp)
	if chk==0 then return #rg>0 and c:GetFlagEffect(m)<Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsCode,m),tp,LOCATION_ONFIELD,0,nil) end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function cm.rmop(e,tp)
	local tg=rsgf.GetTargetGroup()
	local rg=tg:Filter(cm.rmfilter,nil,tp)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)<Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsCode,m),tp,LOCATION_ONFIELD,0,nil) end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.rmop2(e,tp)
	rsop.SelectRemove(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.acon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function cm.aval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()+100
end
function cm.dval(e,c)
	return e:GetHandler():GetBattleTarget():GetDefense()+100
end