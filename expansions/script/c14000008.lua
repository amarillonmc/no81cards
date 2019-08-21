--时穿剑·豪烈剑
local m=14000008
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--chrbeffects
	chrb.dire(c)
	chrb.ChronoDamageEffect(c,CATEGORY_DAMAGE,nil,nil,nil,cm.atktg,cm.atkop)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	chrb.move(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end