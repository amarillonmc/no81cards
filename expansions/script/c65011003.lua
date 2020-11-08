--以斯拉的任性 方舟行动
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011003,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th")
	e1:SetOperation(cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},nil,nil,LOCATION_SZONE,cm.lcon,rscost.cost(cm.cfilter,"tg",LOCATION_DECK),nil,cm.lop)
	local e3,e4=rsef.FV_LIMIT(c,"dis,atk",nil,cm.tg,{ LOCATION_MZONE,LOCATION_MZONE })
	if cm.switch then return end
	cm.switch = true
	local e5=rsef.FC({c,0},EVENT_SPSUMMON_SUCCESS,nil,nil,nil,nil,cm.regcon,cm.regop)
end
function cm.matfilter(c)
	local mat=c:GetMaterial()
	return c:GetSummonType()&(SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK)~=0 and c:GetSummonLocation()==LOCATION_EXTRA and mat and mat:IsExists(cm.matfilter2,1,nil) 
end
function cm.matfilter2(c)
	return rsisr.IsPreSet(c) and c:GetPreviousControler()~=c:GetOwner() 
end
function cm.regcon(e,tp,eg)
	return eg:IsExists(cm.matfilter,1,nil)
end
function cm.regop(e,tp,eg)
	local rg=eg:Filter(cm.matfilter,nil)
	for tc in aux.Next(rg) do
		tc:RegisterFlagEffect(m+100,rsreset.est,0,1)
	end
end
function cm.tg(e,c)
	if rsisr.IsSet(c) and c:GetOwner()~=c:GetControler() then return true end
	return c:GetFlagEffect(m+100)>0
end 
function cm.cfilter(c)
	return c:IsAbleToGraveAsCost() and rsisr.IsSetM(c)
end
function cm.lcon(e,tp)
	return e:GetHandler():GetFlagEffect(m)<=0
end
function cm.lop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rsisr.IsSetM(rc) and rc:IsType(TYPE_LINK) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.thfilter(c)
	return rsisr.IsSetM(c) and c:IsAbleToHand()
end
function cm.act(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsop.SelectOC(rshint.wth)
	local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_HAND) then
		c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	end
end 
