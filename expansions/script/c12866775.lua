--战争恶魔·制服强强剑
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12866755,12866760)
	c:SetSPSummonOnce(id)
	--material
	aux.AddMaterialCodeList(c,12866755)
	aux.AddFusionProcCodeFun(c,{12866755,s.matfilter1},s.matfilter2,1,false,false)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--equip to this
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.matfilter1(c)
	return aux.IsCodeListed(c,12866755)
end
function s.matfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end
function s.eqfilter1(c,tp)
	return (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_FIEND)) and 
	c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqfilter2(c,tp)
	return aux.IsCodeListed(c,12866755) and c:IsType(TYPE_FUSION) and
	c:CheckUniqueOnField(tp) and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_FIEND)) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.eqfilter2(chkc,tp) and 
	chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0
	and Duel.IsExistingTarget(s.eqfilter2,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ct=math.min(ft,2)
	local g1=Duel.SelectTarget(tp,s.eqfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if ct>1 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=Duel.SelectTarget(tp,s.eqfilter1,tp,LOCATION_GRAVE,0,1,1,g1,tp)
		g1:Merge(g2)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain():Filter(aux.NecroValleyFilter(aux.TRUE),nil)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>=tg:GetCount() then
		local tc=tg:GetFirst()
		while tc do	
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(700)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
		end
		Duel.EquipComplete()
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev)
end
function s.negfilter(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_SZONE,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g1=Duel.GetMatchingGroup(s.negfilter,tp,LOCATION_SZONE,0,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.negfilter,tp,LOCATION_SZONE,0,1,1,nil,g)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.NegateEffect(ev)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(12866760) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
