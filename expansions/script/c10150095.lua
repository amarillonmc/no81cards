--王者的威压
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150095)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,nil,"tg",nil,nil,rstg.target(cm.atkfilter,"dum",LOCATION_MZONE),cm.act)
	local e2=rsef.FV_IMMUNE_EFFECT(c,rsval.imoe,cm.extg,{LOCATION_MZONE,0},cm.excon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.excon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e4:SetValue(cm.extg2)
	c:RegisterEffect(e4)
	local e5=rsef.FC(c,EVENT_LEAVE_FIELD,nil,nil,nil,LOCATION_SZONE,cm.descon,cm.desop)
	local e6=rsef.QO(c,nil,{m,0},nil,"des",nil,LOCATION_SZONE,cm.excon,cm.descost,rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD,true,true,cm.except),cm.desop2)
end
function cm.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackAbove(3000) 
end 
function cm.act(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	local tc=Duel.GetFirstTarget()
	if c and tc then
		c:SetCardTarget(tc)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.extg(e,c)
	return c~=e:GetHandler():GetFirstCardTarget()
end
function cm.extg2(e,c)
	return c==e:GetHandler():GetFirstCardTarget()
end
function cm.excon(e)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and tc:IsAttackPos() and tc:IsControler(e:GetHandlerPlayer())
end
function cm.except(e,tp)
	return e:GetHandler():GetFirstCardTarget()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SetTargetCard(c:GetFirstCardTarget())
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.desop2(e,tp)
	local tc=rscf.GetTargetCard()
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end