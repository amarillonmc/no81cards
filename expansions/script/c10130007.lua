--量子驱动-快装车间
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateFieldTriggerMandatoryEffect(c, "BeSet,BeFlippedFaceup", "Draw", nil, "Draw,ShuffleIn2Deck,AddFromDeck2Hand", nil, "Spell&TrapZone", s.drcon, nil, s.drtg, s.drop)
end
function s.dcfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.drcon(e,tp,eg)
	return eg:IsExists(s.dcfilter, 1, nil,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.drop(e,tp,eg)
	--Scl_Quantadrive.Shuffle(tp)
	if Duel.Draw(tp,1,REASON_EFFECT) == 0 or Scl.SelectAndOperateCards("ShuffleIn2Deck",tp,Card.IsAbleToDeck,tp,"Hand",0,1,1,nil)() == 0 or not Scl.IsCorrectlyOperated("Deck") or Duel.GetFlagEffect(tp, id) > 0 then
		return
	end
	local tg = eg:Filter(s.cfilter,nil,tp)
	if #tg > 0 and Scl.SelectYesNo(tp, {id, 0}) then
		Duel.RegisterFlagEffect(tp, id, RESET_EP_SCL, 0, 1)
		local tc = tg:GetFirst()
		if #tg > 1 then
			_,_,tc = Scl.SelectAndOperateCardsFromGroup("Look",tg,tp,aux.TRUE,1,1,nil)()
		end
		Scl.SelectAndOperateCards("Add2Hand",tp,s.thfilter,tp,"Deck",0,1,1,nil,tc:GetCode())()
	end
end 
function s.cfilter(c,tp)
	return c:IsSetCard(0xa336) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.thfilter(c,code)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end