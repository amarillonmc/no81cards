--急袭猛禽-雷云猎鹰
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010024)
function cm.initial_effect(c)
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"dam",nil,"atk,def,dam",
		"de",cm.damcon,nil,cm.damtg,cm.damop)
	local e2 = rsef.SV_Card(c,"mat",cm.check,"cd")
		e2:SetLabelObject(e1)
	local e3 = rsef.QO_NegateActivation(c,"dum",nil,LOCATION_MZONE,
		cm.negcon,rscost.rmxmat(2),nil,nil,cm.extg,cm.exop)
end
function cm.check(e,c)
	local mat = c:GetMaterial()
	if mat:IsExists(cm.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(100)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.damcon(e,tp)
	return e:GetLabel() == 100 and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.cfilter(c)
	return c:FieldPosCheck() and c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,rsloc.mg,0,nil)
	if chk == 0 then return #g > 0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*250)
end
function cm.damop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if not c then return end
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,rsloc.mg,0,nil)
	if #g <= 0 then return end
	local e1,e2 = rscf.QuickBuff(c,"atk+,def+",#g*500)
	local atk = c:GetAttack() / 2
	if atk > 0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler() ~= e:GetHandler() and Duel.IsChainNegatable(ev)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return e:GetHandler():IsType(TYPE_XYZ) end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ~= 1 then return end
	local rc = re:GetHandler()
	local c = rscf.GetFaceUpSelf(e)
	if c and c:IsType(TYPE_XYZ) and rc:IsRelateToEffect(re) then
		rsop.Overlay(e,c,rc)
	end
end