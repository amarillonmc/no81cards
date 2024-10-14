--圣沌忍法 后门
dofile("expansions/script/c20000175.lua")
local cm, m =  fuef.initial(fu_HC, nil, fu_HC.glo)
cm.e1 = fuef.A()
--e2
cm.e2 = fuef.FC("CH"):RAN("F"):OP("op2")
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not (re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and ep==tp) then return end
	if re:GetHandler():IsCode(20000175) then 
		Duel.Hint(HINT_CARD,1-tp,m)
		Duel.Draw(tp,1,REASON_EFFECT) 
	end
	Duel.SetChainLimit(function(e,rp,tp)return tp==rp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)end)
end