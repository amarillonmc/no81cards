--光子龙 深红爆裂
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000056)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,2,cm.ovfilter,aux.Stringid(m,0))
	local e1=rsef.STO(c,EVENT_BATTLE_START,{m,1},{1,m},"dis",nil,nil,rscost.rmxyz(1),cm.distg,cm.disop)
	local e2=rsef.STO(c,EVENT_BATTLED,{m,0},{1,m+100},"des,dam",nil,nil,nil,rsop.target2(cm.fun,aux.TRUE,"des",0,LOCATION_ONFIELD,true,true),cm.desop)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE+RACE_WARRIOR) and c:IsType(TYPE_XYZ)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() 
end
function cm.fun(g,e,tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function cm.desop(e,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then 
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	end
end