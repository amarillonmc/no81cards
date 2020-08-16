--奥泽美咲的质疑
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020216)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,{1,m,1},"neg,des","dsp,dcal",cm.con,nil,cm.tg,cm.act)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and ((re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))) and rp~=tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if not tc then return end
	Duel.ConfirmDecktop(1-tp,1)
	local list = { TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP }
	local res = false
	for _,ctype in pairs(list) do
		if tc:IsType(ctype) and re:IsActiveType(ctype) then
			res = ctype
			break 
		end
	end
	if not res then 
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
	else
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end   
		local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"act",cm.val(res),nil,{0,1},nil,rsreset.pend)
	end
end
function cm.val(ctype)
	return function(e,re)
		return re:IsActiveType(ctype)
	end
end
