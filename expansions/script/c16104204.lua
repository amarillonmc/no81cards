--Orth Saints Lighthill
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104204)
function cm.initial_effect(c)
	local e0,e0_1=rkch.PenTri(c,m,rscost.lpcost(1000))
	local e1=rkch.GainEffect(c,m)
	local e2=rsef.SC(c,EVENT_BATTLE_START,{m,2})
	e2:RegisterSolve(rkch.gaincon(m),nil,nil,cm.seop)
	local e3=rkch.MonzToPen(c,m,EVENT_RELEASE,nil)
	local e4=rkch.PenAdd(c,{m,1},{1},{},false)
	local e5=rsef.SV_IMMUNE_EFFECT(c,cm.val,cm.con)
end
cm.dff=true
function cm.seop(e,tp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRelateToBattle() and not bc:IsRace(RACE_WARRIOR) then
		Duel.Hint(HINT_CARD,0,m)
	   if Duel.SendtoGrave(bc,REASON_EFFECT)>0 then
			local lp=Duel.GetLP(1-tp)
			local num=bc:GetTextAttack()
			if num>lp then
				Duel.SetLP(1-tp,0)
			else
				Duel.SetLP(1-tp,lp-num)
			end
		end
	end
end
function cm.val(e,re)
	return not re:GetHandler():IsRace(RACE_WARRIOR)
end
function cm.con(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end