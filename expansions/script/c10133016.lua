--狂宴之夜
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.A(c,nil,nil,{1,id,"o"})
	e1:SetTarget(s.tg)
	e1:SetOperation(s.act)
end
function s.cfilter(c)
	return ((c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334)) or c:IsCode(10133001)) and c:IsFaceup()
end
function s.thfilter(c,e,tp)
	return aux.IsCodeListed(c,10133001) and c:IsType(TYPE_MONSTER) and (rscf.spfilter2()(c,e,tp) or c:IsAbleToHand())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og1 = Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local og2 = Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ct = Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local b1 = ct >= 2 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2 = Duel.IsPlayerCanDraw(tp,2)
	local b3 = #og1 > 0
	local b4 = true
	local b5 = #og2 > 0
	if chk == 0 then return b1 and (b2 or ct < 3) and (b2 or ct < 4) and (b2 or ct < 5) and (b2 or ct < 6) and e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	local cate = 0
	local dcount = 0
	local dg = Group.CreateGroup()
	if b1 then
		cate = cate|CATEGORY_TOHAND 
		cate = cate|CATEGORY_SEARCH 
		cate = cate|CATEGORY_SPECIAL_SUMMON 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	end
	if b2 then
		cate = cate|CATEGORY_DRAW
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
	if b3 then
		dcount = dcount + 2
		dg:Merge(og1)
	end
	if b4 then
		cate = cate|CATEGORY_DAMAGE
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	end
	if b5 then
		dcount = dcount + #og2
		dg:Merge(og2)
	end
	if dcount > 0 then
		cate = cate|CATEGORY_DESTROY 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,dcount,tp,0)
	end
	e:SetLabel(ct)
end
function s.act(e,tp)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c = e:GetHandler()
	local og1 = Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local og2 = Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ct = Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local b1 = ct >= 2 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2 = Duel.IsPlayerCanDraw(tp,2)
	local b3 = #og1 > 0
	local b4 = true
	local b5 = #og2 > 0
	if b1 then
		local og,tc = rsop.SelectCards("self",tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if tc then
			local th = tc:IsAbleToHand()
			local sp = rscf.spfilter2()(tc,e,tp)
			local op2 = rshint.SelectOption(tp,th,"th",sp,"sp")
			if op2 == 1 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
	end
	if b2 and ct >= 3 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
	end
	if b3 and ct >= 4 then
		local dct = 0
		if #og1 == 1 then 
			dct = 1
		else
			dct = Duel.AnnounceNumber(tp,1,2)
		end
		local dg = og1:RandomSelect(tp,dct)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
	end
	if b4 and ct >= 5 then
		Duel.Damage(1-tp,4000,REASON_EFFECT)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		if Duel.GetLP(1-tp) <= 0 then
			return
		end
	end
	if b5 and ct >= 6 then
		if Duel.Destroy(og2,REASON_EFFECT) > 0 then
			local dg = Duel.GetOperatedGroup():Filter(Card.IsLocation,1,nil,LOCATION_GRAVE+LOCATION_REMOVED)
			for tc in aux.Next(dg) do
				local e1,e2 = rscf.QuickBuff({c,tc},"dis",true,"dise",true)
			end
		end
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,4))
	end
end