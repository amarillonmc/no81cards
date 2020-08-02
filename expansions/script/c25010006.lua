--光之巨人 强壮戴拿
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010006)
function cm.initial_effect(c)
	rsgol.TigaSummonFun(c,m,m-2,0,rscon.turns)
	local e1=rsef.QO_NEGATE(c,"neg",{1,m},"des",LOCATION_MZONE,rscon.negcon(cm.filter))
	e1:SetOperation(cm.negop)
end
function cm.filter(e,tp,re,rp,tg,loc)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and loc&LOCATION_ONFIELD >0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetFaceUpSelf(e)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		local atk=rc:GetAttack()
		if Duel.Destroy(eg,REASON_EFFECT)>0 and c and rc then
			rscf.QuickBuff(c,"atk+",atk)
		end
	end
end