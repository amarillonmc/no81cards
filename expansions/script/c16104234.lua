
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rscf.DefineCard(16104234,"CHURCH")
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,cm.tgfilter,{LOCATION_ONFIELD,0})
	local e3=rsef.FV_INDESTRUCTABLE(c,"effect",1,cm.tgfilter,{LOCATION_ONFIELD,0})
	local e4=rsef.FV_LIMIT_PLAYER(c,"act",cm.limitval,nil,{1,1})
	local e5,e6=rsef.FV_LIMIT_PLAYER(c,"sp,sum",nil,cm.sptg,{1,0})
	local e7=rsef.QO(c,nil,{m,0},1,"td",nil,LOCATION_GRAVE,nil,nil,rsop.target(cm.tdfilter,"td",rsloc.gr,0,1,1,c),cm.actop)
end
function cm.tgfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0xccd) and c~=e:GetHandler()
end
function cm.limitval(e,re)
	local rc=re:GetHandler()
	if rc:IsRace(RACE_WARRIOR) then return false end
	return rc:IsStatus(STATUS_BATTLE_DESTROYED) or rc:IsComplexReason(REASON_DESTROY,true,REASON_EFFECT,REASON_BATTLE)
end
function cm.sptg(e,c)
	return not (c:IsSetCard(0xccd) or c:IsSetCard(0xccb))
end
function cm.tdfilter(c,e,tp)
	return c:IsAbleToDeck() and e:GetHandler():GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp)
	local c=rscf.GetSelf(e)
	if c and rsop.SelectToDeck(tp,cm.tdfilter,tp,rsloc.gr,0,1,3,c,{},e,tp)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=c:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end