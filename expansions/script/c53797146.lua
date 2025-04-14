if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	s.zero_seal_effect=e1
	SNNM.zero_seal_check(id,e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep~=tp and Duel.IsChainNegatable(ev)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)>0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(53797644,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=re:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if ec:IsStatus(STATUS_LEAVE_CONFIRMED) and ec:IsRelateToEffect(re) and ec:IsControler(1-tp) then
		ec:CancelToGrave()
		if ec:IsAbleToHand() then g:AddCard(ec) end
		ec:CancelToGrave(false)
	end
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=0 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		local ec=re:GetHandler()
		if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_ONFIELD,nil)
			if ec:IsAbleToHand() then g:AddCard(ec) end
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then Duel.HintSelection(sg) Duel.SendtoHand(sg,nil,REASON_EFFECT) end
			if not (#sg>0 and ec==sg:GetFirst()) then ec:CancelToGrave(false) end
		end
		e:GetHandler():SetFlagEffectLabel(53797644,1)
	end
end
s.category=CATEGORY_DRAW
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.exop(e,tp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
