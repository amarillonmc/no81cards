--艾雷德尔神父
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171013)
function cm.initial_effect(c)
	local e1=rsds.TributeFun(c,m,nil,nil,nil,cm.op)
	local e2=rsds.SpExtraFun(c,m,m-10,m-6,rscon.excard2(Card.IsSetCard,LOCATION_MZONE,LOCATION_MZONE,1,nil,0xa335))
end
function cm.op(e,tp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,m,rsreset.pend,0,1)
	local e1=rsef.FC({c,tp},EVENT_RELEASE)
	e1:SetOperation(cm.regop)
	e1:SetReset(rsreset.pend)
	local e2=rsef.RegisterClone({c,tp},e1,"code",EVENT_REMOVE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsReason,1,nil,REASON_COST) and re:IsHasType(0x7e0) and rp==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end