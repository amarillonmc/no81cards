--往复交织而无法离舍的奇迹
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000087)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,{1,m,1},"td,con","tg",cm.con,nil,rstg.target(cm.tfilter,nil,LOCATION_MZONE),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
end
function cm.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp~=tp and rc:IsLevelAbove(1)  
end
function cm.tfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return c:IsLevelAbove(1) and rc:IsLevelAbove(c:GetLevel())
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local rc=re:GetHandler()
	local lv=rc:GetLevel()
	local e1=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imes,nil,rsreset.est_pend)
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"sp",nil,cm.limittg,{0,1},nil,rsreset.pend)
	e2:SetLabel(lv)
	local tg1=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	local cg1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)
	if ft1>0 and #cg1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		local ct,og=rsgf.SelectToDeck(tg1,tp,aux.TRUE,1,math.min(ft1,#cg1),nil)
		if ct<=0 then return end
		rshint.Select(tp,"ctrl")
		local cg2=cg1:Select(tp,ct,ct,nil)
		Duel.HintSelection(cg2)
		Duel.GetControl(cg2,tp,PHASE_END,1)
	end
end
function cm.limittg(e,c)
	return c:IsLevelAbove(e:GetLabel())
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end