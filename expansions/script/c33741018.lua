--DEchoesD - Vibing
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(s.cfilter,nil,tp)
	if chk==0 then return Duel.GetMatchingGroupCount(DEchoes.ExtraKernel,tp,LOCATION_EXTRA,0,nil)>=ct end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local kg=DEchoes.DestroyExtraKernel(tp,ct,ct)
	if not kg or Duel.Destroy(kg,REASON_EFFECT)==0 then return end
	local g=eg:Filter(s.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
	end
	Duel.Destroy(g,REASON_EFFECT)
end
