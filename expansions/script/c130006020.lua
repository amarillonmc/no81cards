--反转世界的幻梦 提亚拉
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006020,"FanZhuanShiJie")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,99,true)
	local e1 = rsef.SV_Card(c,"mat",cm.val,"cd")
	local e2 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"ae",nil,nil,nil,rscon.sumtypes("fus"),nil,cm.tg,cm.op)
	e2:SetLabelObject(e1)
end
function cm.ffilter(c)
	return not c:IsControler(c:GetOwner()) and c:IsOnField()
end
function cm.val(e,c)
	local mat = c:GetMaterial()
	local ct = mat:GetClassCount(Card.GetCode)
	e:SetLabel(ct)
	local atk = mat:GetSum(Card.GetBaseAttack)
	local e1 = rscf.QuickBuff(c,"batk",atk,"rst",rsrst.std_ntf)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsfz.IsSetM(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct = e:GetLabelObject():GetLabel()
	local b1 = ct >= 1 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2 = ct >= 3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) > 0
	local b3 = ct >= 6 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA) > 0
	if chk == 0 then return b1 or b2 or b3 end
	local cate = 0 
	if b1 then
		cate = cate | CATEGORY_TOHAND
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
	if b2 then
		cate = cate | CATEGORY_SPECIAL_SUMMON 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_DECK)
	end
	if b3 then
		cate = cate | CATEGORY_REMOVE 
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_EXTRA)
	end
	e:SetCategory(cate)
	e:SetLabel(ct)
end
function cm.op(e,tp)
	local ct = e:GetLabel()
	if ct >= 1 then 
		rsop.SelectOC("th")
		rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
	end
	local g = Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if ct >= 3 and #g > 0 then
		Duel.ConfirmCards(tp,g)
		local sg = g:Filter(rscf.spfilter2(),nil,e,tp)
		if #sg > 0 and rshint.SelectYesNo(tp,"sp") then
			rsgf.SelectSpecialSummon(sg,tp,aux.TRUE,1,1,nil,{},e,tp)
		end 
	end
	g = Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if ct >= 6 and #g > 0 then
		Duel.ConfirmCards(tp,g)
		local rg = g:Filter(cm.cfilter,nil,tp,g)
		if #rg > 0 then
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.cfilter(c,tp,g)
	return c:IsAbleToRemove(c,tp,POS_FACEDOWN) and g:IsExists(Card.IsCode,1,c,c:GetCode())
end