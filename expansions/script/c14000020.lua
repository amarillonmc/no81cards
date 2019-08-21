--时穿剑阵·破军
local m=14000020
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,5,5,cm.lcheck)
	c:EnableReviveLimit()
	--chrbeffects
	chrb.dire(c,true,5)
	chrb.ChronoDamageEffect(c,nil,EFFECT_FLAG_CARD_TARGET,nil,nil,cm.atktg,cm.atkop,nil,true)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,LOCATION_MZONE)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	chrb.move(e,tp,eg,ep,ev,re,r,rp,true)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end