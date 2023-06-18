--伐楼利拿·巴瑞恩特
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009639,"Vairina")
function cm.initial_effect(c)
	aux.AddCodeList(c,40009579)
	local e1 = rscf.AddSpecialSummonProcdure(c,LOCATION_HAND,cm.sprcon,nil,
		cm.sprop,nil,{1,m,"o"})
	e1:SetValue(SUMMON_VALUE_SELF)
	local e2 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"th",{1,m+100},"th","de",cm.thcon,
		nil,cm.thtg)
end
function cm.sprcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.ofilter,tp,LOCATION_MZONE,0,1,nil,tp) 
end
function cm.ofilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp) > 0 and c:CheckSetCard("Vairina","BlazeMaiden") and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonType(SUMMON_VALUE_SELF)
end
function cm.sprop(e,tp)
	local c = e:GetHandler()
	local og,tc = rsop.SelectCards("xmat",tp,cm.ofilter,tp,LOCATION_MZONE,0,1,1,nil)
	local og2 = tc:GetOverlayGroup()
	if #og2 > 0 then
		Duel.Overlay(c, og2)
	end
	Duel.Overlay(c, og)
end
function cm.thcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.thfilter(c,set)
	return c:IsAbleToHand() and c:CheckSetCard(set) --c:IsSetCard(set)
end
function cm.thfilter2(c)
	return c:IsAbleToHand() and (c:IsCode(40009579) or (aux.IsCodeListed(c,40009579) and c:IsType(TYPE_RITUAL)))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c = e:GetHandler()
	local og = c:GetOverlayGroup()
	local list = { "BlazeMaiden", "BlazeTalisman", "Vairina" }
	local res = { false, false, false }
	local resct = 0
	for mx, set in pairs(list) do
		if og:IsExists(Card.CheckSetCard,1,nil,set) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,set) then
			res[mx] = set
			resct = resct + 1
		end
	end
	if chk == 0 then return resct > 0 and (resct ~= 3 or Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,resct == 3 and 4 or resct, tp, LOCATION_DECK)
	e:SetOperation(cm.thop(res))
end
function cm.thop(res)
	return function(e,tp,...)
		local tg = Group.CreateGroup()
		for _, set in pairs(res) do
			if set then
				local g = rsop.SelectCards("th",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,set)
				tg:Merge(g)
			end
		end
		if #tg > 0 and Duel.SendtoHand(tg,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,tg)
			if tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and #tg == 3 then
				rsop.SelectExPara(nil,true)
				rsop.SelectOperate("th",tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,{})
			end
		end
	end
end