--铁虹的强袭兵
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700723
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsneov.TunerFun(c,1900)
	rsneov.RDTurnFun(c,CATEGORY_DRAW,nil,1600,cm.tg,cm.op,true)
	rsneov.LPChangeFun(c) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTargetRange(0,1)
			e2:SetValue(cm.aclimit)
			e2:SetCondition(cm.actcon)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
