--铳影-朴景丽
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825602.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3)
	c:EnableReviveLimit()
	chiki.c4a71Limit(c)
	chiki.c4a71tohand(c)
	chiki.c4a71kang(c,c12825602.discon,c12825602.distg,c12825602.disop,CATEGORY_NEGATE,12825602,1131,12825607)
end
function c12825602.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(12825612)>0 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c12825602.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c12825602.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
