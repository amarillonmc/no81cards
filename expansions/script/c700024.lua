--Breath Of THE DES ALIZES
if not pcall(function() require("expansions/script/c700020") end) then require("script/c700021") end
local m,cm = rscf.DefineCard(700024,"Breath")
function cm.initial_effect(c)
	local e1,e2,e3,e4 = rsbh.ExMonFun(c,m,LOCATION_ONFIELD,3)
	local e5 = rsef.FV_LIMIT(c,"dis",nil,cm.distg,{LOCATION_ONFIELD,LOCATION_ONFIELD })
	local e6 = rsef.FC(c,EVENT_ADJUST,nil,nil,nil,LOCATION_MZONE,cm.rescon,cm.resop)
	local e7 = rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_MZONE,cm.mvcon,nil,nil,cm.mvop)
end
function cm.distg(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c) and e:GetHandler()~=c
end
function cm.rescon(e,tp)
	local c=e:GetHandler()
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return false end
	local cg = c:GetColumnGroup()
	cg:RemoveCard(c)
	return cg:IsExists(Card.IsReleasableByEffect,1,nil)
end
function cm.resop(e,tp)
	local c=e:GetHandler()
	local cg = c:GetColumnGroup()
	local rg = cg:Filter(Card.IsReleasableByEffect,c)
	if #rg>0 then
		rshint.Card(m)
		Duel.Release(rg,REASON_EFFECT)
		Duel.Readjust()
	end
end
function cm.mvcon(e,tp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function cm.mvop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	rsbh.MoveSZone(c,c,tp)
end