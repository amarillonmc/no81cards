--TheDesAlizes Flavor
if not pcall(function() require("expansions/script/c700020") end) then require("script/c700021") end
local m,cm = rscf.DefineCard(700022,"Breath")
function cm.initial_effect(c)
	local e1,e2,e3,e4 = rsbh.ExMonFun(c,m,LOCATION_SZONE,2)
	--local e5 = rsef.FC(c,EVENT_ADJUST,nil,nil,nil,LOCATION_MZONE,cm.matcon,cm.matop)
	local e6 = rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_MZONE,cm.mvcon,nil,nil,cm.mvop)
	
	local e7 = rsef.FC(c,EVENT_CHAINING,{m,1},nil,nil,LOCATION_MZONE,cm.matcon2,cm.matop2)
	local e8 = rsef.FC(c,EVENT_ATTACK_ANNOUNCE,{m,1},nil,nil,LOCATION_MZONE,cm.matcon3,cm.matop3)
end
function cm.matcon2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = re:GetHandler()
	return c:GetFlagEffect(m) == 0 and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and c:IsType(TYPE_XYZ) and rp ~= tp
end
function cm.matop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = re:GetHandler()
	if not c:IsType(TYPE_XYZ) or not rc:IsRelateToEffect(re) or not rc:IsCanOverlay() or not Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then return end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	rshint.Card(m)
	Duel.Overlay(c,eg)
end
function cm.matcon3(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local bc = Duel.GetAttacker()
	return c:GetFlagEffect(m) == 0 and bc:IsControler(1-tp) and bc:IsCanOverlay() and c:IsType(TYPE_XYZ) 
end
function cm.matop3(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local bc = Duel.GetAttacker()
	if not c:IsType(TYPE_XYZ) or not bc:IsCanOverlay() or not Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then return end
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	rshint.Card(m)
	Duel.Overlay(c,Group.FromCards(bc))
end
function cm.matcon(e,tp)
	local c=e:GetHandler()
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return false end
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()<2 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.matop(e,tp)
	rshint.Card(m)
	local c = e:GetHandler()
	local ct = 2-c:GetOverlayCount()
	local g = Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,nil)
	if #g<=0 or ct<=0 then return end
	local tg = rsgf.SelectSolve(g,HINTMSG_XMATERIAL,1-tp,aux.TRUE,math.min(ct,#g),math.min(ct,#g),nil,{})
	if #tg>0 then
		local og = Group.CreateGroup()
		for tc in aux.Next(tg) do
			og:Merge(tc:GetOverlayGroup())
		end
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tg) 
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