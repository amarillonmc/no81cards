--概念虚械 正义
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	local e1=fuef.F(c,nil,EFFECT_CANNOT_ACTIVATE,EFFECT_FLAG_PLAYER_TARGET,"M",{0,1},1,nil,cm.con1,nil,nil,c,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	local e2=fuef.SC(c,{m,0},EVENT_PRE_DAMAGE_CALCULATE,"HINT",nil,cm.con2,cm.op2,c,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc==c then tc=Duel.GetAttacker() end
	if not (tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(1-tp)) then return end
	local val=tc:GetBaseAttack()>tc:GetBaseDefense() and tc:GetBaseDefense() or tc:GetBaseAttack()
	local e1=fuef.S(c,nil,EFFECT_SET_ATTACK_FINAL,EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE,"M",val,nil,nil,nil,{tc,1},RESET_PHASE+PHASE_DAMAGE)
	local e2=fuef.Clone(e1,{tc,1},"COD",EFFECT_SET_DEFENSE_FINAL)
end