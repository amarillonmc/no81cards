--急袭猛禽-侦察林鸮
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010026)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_XYZ),1)
	local e2 = rsef.I(c,"th",1,"se,th",nil,LOCATION_MZONE,cm.thcon,
		nil,rsop.target(aux.TRUE,"dum",0,LOCATION_HAND),cm.thop)
end
function cm.thcon(e,tp)
	local c = e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thop(e,tp)
	local e1 = rsef.FV_Player({e:GetHandler(),tp},"act~",cm.imval,
		nil,{1,0},nil,nil,nil,rsrst.ep)
	local hg = Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #hg <= 0 then return end
	local cg = hg:RandomSelect(tp,1)
	Duel.HintSelection(cg)
	Duel.ConfirmCards(tp,cg)
	local tc = cg:GetFirst()
	rsop.SelectExPara("th",true)
	rsop.SelectOperate("th",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},tc)
end
function cm.thfilter(c,tc)
	local list = { TYPE_SPELL,TYPE_TRAP,TYPE_MONSTER }
	for _,ctype in pairs(list) do
		if c:IsType(ctype) and not tc:IsType(ctype) then return false end
	end
	return c:IsSetCard(0xba) and c:IsAbleToHand()
end
function cm.imval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end