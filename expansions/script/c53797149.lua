if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	s.zero_seal_effect=e1
	SNNM.zero_seal_check(id,e1)
end
function s.filter(c,tp)
	return c:IsAttackAbove(2000) and c:IsSummonPlayer(tp)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)>0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(53797644,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.tdfilter(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and eg:IsExists(s.filter,1,nil,1-tp) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=0 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(1-tp,s.tdfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_RULE)
		end
		e:GetHandler():SetFlagEffectLabel(53797644,1)
	end
end
s.category=CATEGORY_RECOVER
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2000)
end
function s.exop(e,tp)
	Duel.Recover(1-tp,2000,REASON_EFFECT)
end
