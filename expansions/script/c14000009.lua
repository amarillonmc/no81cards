--时穿剑阵·四象阵
local m=14000009
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,4,4,cm.lcheck)
	c:EnableReviveLimit()
	--chrbeffects
	chrb.dire(c,true)
	chrb.ChronoDamageEffect(c,CATEGORY_TOGRAVE,nil,nil,nil,cm.atktg,cm.atkop,nil,true)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==#g
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	chrb.move(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #cg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE) 
	end
end