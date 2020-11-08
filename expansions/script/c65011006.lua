--以斯拉的裁决 异域追凶
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011006,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"tg")
	e1:SetOperation(cm.act) 
	local e2=rsef.I(c,nil,{1,m+100},"des,sp","tg",LOCATION_SZONE,cm.descon,rscost.cost(1,"dish"),rstg.target2(cm.fun,aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.dcon)
	c:RegisterEffect(e3)
end
function cm.dcon(e,tp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.cfilter(c)
	return c:IsFacedown() or rsisr.IsSet(c)
end
function cm.tgfilter(c)
	return rsisr.IsSetM(c) and c:IsAbleToGrave()
end
function cm.act(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsop.SelectOC("tg")
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	end
end 
function cm.descon(e,tp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function cm.desop(e,tp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard()
	if not c then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		rsop.SelectOC("sp",true)
		rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(rsisr.IsSet)),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not rsisr.IsSet(c)
end