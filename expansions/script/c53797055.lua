local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.fgoal(g,e,tp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,g)
end
function s.spfilter(c,e,tp,g)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_NORMAL) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,g)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atyp=0x58020c0
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK+LOCATION_EXTRA)==0 then return false end
	local g=Duel.GetReleaseGroup(tp,false,REASON_COST)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<1 and not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,0,LOCATION_EXTRA,1,nil,TYPE_RITUAL) then atyp=0x5802040 end
	for _,v in ipairs({0x40,0x2000,0x800000,0x4000000}) do
		if not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_EXTRA,1,nil) and not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsType),tp,0,LOCATION_EXTRA,1,nil,v) then atyp=atyp&(~v) end
	end
	g=g:Filter(Card.IsType,nil,atyp)
	if chk==0 then return g:CheckSubGroup(s.fgoal,1,#g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}
	local t={}
	local type=0
	for i=1,6 do
		if g:IsExists(Card.IsType,1,nil,types[i]) and Duel.SelectYesNo(tp,aux.Stringid(id,i)) then type=type|types[i] table.insert(t,types[i]) end
	end
	local sg=g:Filter(Card.IsType,nil,type)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(Duel.GetOperatedGroup():GetCount(),table.unpack(t))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,nil):GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)==0 then return end
	local t={e:GetLabel()}
	local ct,types=0,{}
	for k,v in ipairs(t) do
		if k==1 then ct=v else table.insert(types,v) end
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	local rg=Group.CreateGroup()
	for _,v in ipairs(types) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsType,1,ct,rg,v)
		if #sg>0 then rg:Merge(sg) end
	end
	if #rg==0 then return end
	Duel.BreakEffect()
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	local rct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if rct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetLabel(rct)
		e1:SetTarget(s.sumlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		tc:RegisterEffect(e3,true)
	end
end
function s.sumlimit(e,c)
	return c:GetBaseAttack()<=e:GetLabel()*200
end
