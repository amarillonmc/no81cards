--能量体
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174034
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.SV_UPDATE(c,"atk",cm.val)
	local e2=rsef.I(c,{m,0},1,"des","tg",LOCATION_MZONE,cm.con(2000),rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rstg.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
	local e3=rsef.SV_IMMUNE_EFFECT(c,cm.imval,cm.con(4000))
end
function cm.val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*1000
end
function cm.con(atk)
	return function(e)
		return e:GetHandler():IsAttackAbove(atk)
	end
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.imval(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer() and re:IsActivated()
end