--桃源乡的威望
local m=11621401
local cm=_G["c"..m]
function c11621401.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1) 
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--special summon (hand/grave)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,11621401)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,11621402)
	e5:SetTarget(cm.settg)
	e5:SetOperation(cm.setop)
	c:RegisterEffect(e5)
end
cm.SetCard_THY_PeachblossomCountry=true 
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.atkfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)*600
end
--
function cm.refilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsType(TYPE_TRAP) and (val==nil or val(re,c)~=true)
end
function cm.refilter2(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsType(TYPE_TRAP) and  (val==nil or val(re,c)~=true) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) or Duel.IsExistingMatchingCard(cm.refilter2,tp,0,LOCATION_ONFIELD,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.NecroValleyFilter()(c) then return end
	local g=Duel.GetMatchingGroup(cm.refilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	if Duel.IsExistingMatchingCard(cm.refilter2,tp,0,LOCATION_ONFIELD,1,nil,tp) then
		local dg=Duel.GetMatchingGroup(cm.refilter2,tp,0,LOCATION_ONFIELD,nil,tp)
		g:Merge(dg)
	end
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.Release(sg,REASON_EFFECT)<1 then
			Duel.Release(sg,REASON_COST)
		end
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
--02
function cm.setfilter(c)
	return c.SetCard_THY_PeachblossomCountry and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end