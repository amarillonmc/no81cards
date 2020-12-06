--神越演武
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000066)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,{1,m,1},"dam","tg",cm.con,rscost.lpcost(true),rstg.target(Card.IsFaceup,nil,LOCATION_MZONE),cm.act)
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
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsPlayerCanDraw(tp,1)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local atk=tc:GetBaseAttack()
	if atk>0 and rsop.SelectYesNo(tp,{m,0}) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end