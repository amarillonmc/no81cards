--龙血师团-骸血眼
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009471)
function cm.initial_effect(c)
	local e1,e2,e3 = rsdb.XyzFun(c,m,m-2)
	local e4 = rsef.QO(c,nil,{m,0},nil,nil,"tg",LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target2(cm.fun,cm.cfilter,nil,LOCATION_ONFIELD,LOCATION_ONFIELD),cm.op)
end
function cm.cfilter(c,e,tp)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and aux.disfilter1(c)) or (c:IsType(TYPE_TRAP) and c:IsCanTurnSet() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsAbleToChangeControler()))
end 
function cm.fun(g,e,tp)
	if g:GetFirst():IsType(TYPE_SPELL) then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
	else
		e:SetCategory(0)
	end
end
function cm.op(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		local e1 = rsef.SV_IMMUNE_EFFECT(c,cm.val(aux.ExceptThisCard(e)),nil,rsreset.est_pend)
	elseif tc:IsType(TYPE_SPELL) then
		local e1,e2 = rscf.QuickBuff({c,tc},"dis,dise")
	else
		if c:IsCanTurnSet() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsAbleToChangeControler() then
			tc:CancelToGrave()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function cm.val(c)
	return function(e,re)
		return not c or re:GetHandler() ~= c
	end
end