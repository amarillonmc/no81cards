if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
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
	SNNM.zero_seal_check(id,e1,3)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)>0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(53797644,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=0 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_MOVE)
		e1:SetCondition(s.regcon)
		e1:SetOperation(s.regop)
		e1:SetLabelObject(g)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetCondition(s.tgcon)
		e2:SetOperation(s.tgop)
		e2:SetLabelObject(g)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		e:GetHandler():SetFlagEffectLabel(53797644,1)
	end
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK) and not c:IsLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	g:ForEach(Card.RegisterFlagEffect,id+500,RESET_EVENT+RESETS_STANDARD,0,1)
	e:GetLabelObject():Merge(g)
end
function s.filter(c)
	return c:GetFlagEffect(id+500)>0 and c:IsAbleToGrave()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():FilterCount(s.filter,nil)>0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.filter,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	g:DeleteGroup()
end
s.category=CATEGORY_RELEASE
function s.rlfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function s.exop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then Duel.Release(g,REASON_EFFECT) end
end
