--大地之光 盖亚SV
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010009)
function cm.initial_effect(c)
	rsgol.GaiaSummonFun(c,m,10)
	--local e1=rsef.SV_IMMUNE_EFFECT(c,cm.val)
	local e2=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e3=rsef.FV_LIMIT_PLAYER(c,"rm",nil,nil,{0,1})
	local e4=rsef.FV_LIMIT_PLAYER(c,"act",cm.disval,nil,{0,1})
	local e5=rsef.QO_NEGATE(c,"neg",{1,m},"des",LOCATION_MZONE,rscon.negcon(2,true),rscost.rmxyz(1))   
	local e6=rsef.QO_NEGATE(c,"sp",{1,m},"des",LOCATION_MZONE,cm.discon,rscost.rmxyz(1))
	local e7=rsgol.ToExtraEffect(c)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(m-1) and c:GetOverlayCount()<=0
end
function cm.val(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.disval(e,re)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsOnField()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end