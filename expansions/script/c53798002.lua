local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE) and not c:IsHasEffect(id)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(id)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_MOVE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.regcon)
		e2:SetOperation(s.regop)
		e2:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e2,true)
		local ng=Group.CreateGroup()
		ng:KeepAlive()
		e1:SetLabelObject(ng)
		e2:SetLabelObject(ng)
	end
end
function s.chfilter(c)
	return c:IsOnField() and not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg:Filter(s.chfilter,nil)) do
		tc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1)
		e:GetLabelObject():AddCard(tc)
	end
end
function s.cfilter1(c,tp,sc)
	local te=c:IsHasEffect(id)
	if not te then return false end
	local sg=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,sc,tp,te:GetLabelObject():Clone())
	return c:IsAbleToGraveAsCost() and #sg>0 and Duel.GetMZoneCount(tp,Group.__add(c,sg))>0
end
function s.cfilter2(c,tp,g)
	return g:IsContains(c) and c:IsReleasable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(id)
	local sg=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp,te:GetLabelObject():Clone())
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.Release(sg,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToDeck())
end
function s.fselect(g)
	return g:IsExists(Card.IsAbleToDeck,3,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return (e:IsCostChecked() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and dg:CheckSubGroup(s.fselect,4,4,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=dg:SelectSubGroup(tp,s.fselect,false,4,4,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.tdcon)
		e1:SetOperation(s.tdop)
		Duel.RegisterEffect(e1,tp)
		Duel.SendtoDeck(Group.__sub(g,tc),nil,2,REASON_EFFECT)
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id+500)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
