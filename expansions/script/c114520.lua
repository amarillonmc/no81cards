--外道梦魇
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114520)
function cm.initial_effect(c)
	local e1 = rsef.A(c,EVENT_CHAINING,nil,{1,m,"o"},nil,nil,cm.con,nil,cm.tg,cm.act)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,rsloc.og,rsloc.og,1,e:GetHandler())
	local b2 = Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3 = Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk == 0 then return b1 or b2 or b3 end
	local op = rshint.SelectOption(tp,b1,"rm",b2,"th",b3,"sp")
	if op == 1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,rsloc.og)
	elseif op == 2 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,PLAYER_ALL,LOCATION_MZONE)
	elseif op == 3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,PLAYER_ALL,LOCATION_MZONE)
	end
	e:SetLabel(op)
end
function cm.thfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.pfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.act(e,tp)
	local c = e:GetHandler()
	local op = e:GetLabel()
	if op == 1 then
		local ct,og,tc = rsop.SelectRemove(tp,Card.IsAbleToRemove,tp,rsloc.og,rsloc.og,1,1,aux.ExceptThisCard(e),{})
		if tc and tc:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(cm.distg)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
		end
	elseif op == 2 then
		if rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,nil,{}) > 0 then
			local g = rsop.SelectSolve("pos",tp,cm.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,{})
			if #g > 0 then
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		end
	elseif op == 3 then
		if rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE },e,tp) > 0 then
			local g = rsop.SelectSolve("pos",tp,cm.pfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,{})
			if #g > 0 then
				local pos = Duel.SelectPosition(tp,g:GetFirst(),POS_FACEUP)
				Duel.ChangePosition(g,pos)
			end
		end
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.pfilter2(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end