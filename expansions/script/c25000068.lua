--银龙一闪
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000068)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_ATTACK_ANNOUNCE,nil,{1,m,1},"dam,tg","tg",cm.con,rscost.lpcost(100,true),rstg.target2(cm.fun,Card.IsFaceup,nil,LOCATION_MZONE),cm.act)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hcon)
	c:RegisterEffect(e2)   
end
function cm.hcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function cm.con(e,tp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.fun(g,e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.act(e,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetLabel(tp)
		e1:SetCondition(cm.damcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if #g>0 and Duel.SendtoGrave(g,REASON_RULE)>0 then
		local tc=rscf.GetTargetCard(Card.IsFaceup)
		if not tc then return end
		local atk=tc:GetBaseAttack()
		if atk>0 and rsop.SelectYesNo(tp,{m,0}) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function cm.damcon(e)
	return Duel.GetTurnPlayer()==e:GetLabel()
end