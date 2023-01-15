--恶食大狼
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,10133001)
	aux.EnableChangeCode(c,10133001,LOCATION_EXTRA+LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),
		2,2,s.gcheck)
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"des",{1,id},"des","de",nil,nil,
		s.destg,s.desop)
	local e2 = rsef.FC_Easy(c,EVENT_DESTROYED,nil,LOCATION_MZONE,s.damcon,s.damop)
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.recon)
	e4:SetValue(LOCATION_DECK)
	c:RegisterEffect(e4)
end
function s.recon(e,tp)
	local c = e:GetHandler()
	return c:IsPosition(POS_FACEUP) and c:IsType(rscf.extype)
end
function s.gcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_BEAST)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(0)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	if #g <= 0 then return end
	local tg = g:GetMinGroup(Card.GetAttack)
	if #tg > 1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg = tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		tg = sg
	end
	Duel.Destroy(tg,REASON_EFFECT) 
end
function s.dfilter(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsReason(REASON_EFFECT)
end
function s.damcon(e,tp,eg)
	return eg:IsExists(s.dfilter,1,nil,tp)
end
function s.damop(e,tp,eg)
	rshint.Card(id)
	local ct = eg:FilterCount(s.dfilter,nil,tp)
	Duel.Damage(1-tp,ct*800,REASON_EFFECT)
end
