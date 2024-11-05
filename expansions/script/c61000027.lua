--怪翎衣 翠雀展屏
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),2,127,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.desfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
		and (c:IsRace(RACE_PYRO) and c:IsType(TYPE_MONSTER) or c:IsSetCard(0xb9))
end
function s.gcheck(g,tp,ec,dg)
	if ec then
		if g:IsContains(ec) then return false end
		return dg:IsExists(s.eqfilter,1,ec,tp,g)
	end
	return true
end
function s.eqfilter(c,tp,g)
	if g and g:IsContains(c) then
		return false
	end
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.cfilter(c)
	return c:IsType(TYPE_EQUIP) and bit.band(c:GetRace(),RACE_WINDBEAST)==RACE_WINDBEAST
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chkc then return chkc:IsOnField() and s.desfilter(chkc) end
	if chk==0 then return ct>0 and g:CheckSubGroup(s.gcheck,1,ct,tp,c,g) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,1,ct,tp,aux.ExceptThisCard(e),g)
	if sg and sg:GetCount()>0 and Duel.Destroy(sg,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local eqg=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,c,tp)
		if #eqg>0 then
			if not Duel.Equip(tp,c,eqg:GetFirst()) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(eqg:GetFirst())
			e1:SetValue(s.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.eqatk(c)
	return c:GetBaseDefense()
end
function s.val(e,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return g:GetSum(s.eqatk)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end