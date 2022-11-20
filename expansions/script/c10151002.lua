--星尘之光
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151002)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,{1,m,1},"neg,sp",nil,rscon.negcon(cm.filter),nil,cm.tg,cm.act)
	if cm.switch then return end
	cm.switch=true
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(cm.efftg)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	Duel.RegisterEffect(e1,tp)
end
function cm.efftg(e,c)
	return c:GetFlagEffect(m)>0
end
function cm.synfilter(c,rc)
	return c:IsSetCard(0x66,0x1017,0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(rc)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then 
		rc:RegisterFlagEffect(m,0,0,1)
		local res=Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,rc)
		rc:ResetFlagEffect(m)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) or not rc:IsRelateToEffect(re) then return end
	rc:RegisterFlagEffect(m,0,0,1)
	rshint.Select(tp,"sp")
	local tc=Duel.SelectMatchingCard(tp,cm.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,rc):GetFirst()
	if tc then 
		Duel.SynchroSummon(tp,tc,rc)
	end
	rc:ResetFlagEffect(m) 
end
