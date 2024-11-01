local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.filter(c,e,tp)
	return c:IsCode(10110717) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)==0 or tc:IsFaceup() then return end
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetLabel(tc:GetFieldID())
	e1:SetLabelObject(tc)
	e1:SetOperation(s.posop)
	Duel.RegisterEffect(e1,tp)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local fid,tc=e:GetLabel(),e:GetLabelObject()
	if fid~=tc:GetFieldID() then
		e:Reset()
		return
	end
	if rp==tp or tc:IsFaceup() then return end
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	if fid~=tc:GetFieldID() then e:Reset() end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsChainSolving() then return false end
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or bit.band(r,REASON_EFFECT)==0 then return false end
	local g,loc,seq=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if not g or #g==0 then return false end
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone&(1<<seq)==0 then return false end
	local sg=e:GetLabelObject()
	sg:Clear()
	sg:Merge(g)
	return true
end
function s.desfilter(c,dam)
	return c:GetAttack()>dam and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	local dg=g:Filter(s.desfilter,nil,ev)
	if chk==0 then return #dg>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:FilterSelect(tp,s.desfilter,1,1,nil,ev)
	if #sg>0 then Duel.HintSelection(sg) Duel.Destroy(sg,REASON_EFFECT) end
end
