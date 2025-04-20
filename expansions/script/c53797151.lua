if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	s.zero_seal_effect=e1
	SNNM.zero_seal_check(id,e1,2)
end
function s.cfilter(c,e,tp)
	local se,sp=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT,SUMMON_INFO_REASON_PLAYER)
	return se and sp~=tp and se:IsActivated() and e:GetOwnerPlayer()~=se:GetOwnerPlayer()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	if Duel.SendtoGrave(c,REASON_COST)>0 and c:IsLocation(LOCATION_GRAVE) then c:RegisterFlagEffect(53797644,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.filter(c,tp)
	return c:IsControler(1-tp) and c:IsControlerCanBeChanged()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,tp) end
	local g=eg:Filter(s.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=0 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
		local tc=SNNM.Select_1(Duel.GetTargetsRelateToChain():Filter(Card.IsControler,nil,1-tp),tp,HINTMSG_CONTROL)
		Duel.NegateSummon(eg)
		if tc then Duel.GetControl(tc,tp,PHASE_END,1) end
		e:GetHandler():SetFlagEffectLabel(53797644,1)
	end
end
s.category=CATEGORY_DESTROY
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
end
function s.exop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
