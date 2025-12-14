--创界神 密特拉
local s,id=GetID()


function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1) 
	e1:SetCondition(s.pcon1)
	e1:SetTarget(s.ptg1)
	e1:SetOperation(s.pop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id) 
	e2:SetTarget(s.mtg1)
	e2:SetOperation(s.mop1)
	c:RegisterEffect(e2)
end

function s.exfilter(c)
	return (c:IsCode(id) or s.AwakenedDragon(c))
		and c:IsAbleToExtra()
end
function s.xyzfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and s.AwakenedDragon(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.matfilter(c,sc,tp)
	return c:IsFaceup() and s.AwakenedDragon(c)
		and c:IsCanBeXyzMaterial(sc,tp)
end
function s.pcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		   and e:GetHandler():IsDestructable()
end
function s.ptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
-- 把组 g 当作灵摆卡使用加入额外卡组
function s.SendGroupToExtraAsPendulum(g,tp,reason,e)
	local handler = e and e:GetHandler() or nil
	local tc=g:GetFirst()
	while tc do
		if not tc:IsType(TYPE_PENDULUM) then
			local e1=Effect.CreateEffect(handler)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_PENDULUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		tc=g:GetNext()
	end
	Duel.SendtoExtraP(g,tp,reason)
end
function s.pop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		s.SendGroupToExtraAsPendulum(g,tp,REASON_EFFECT,e)
	else
		return
	end
	local g1=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(
		function(c) return c:IsFaceup() and s.AwakenedDragon(c) end,
		tp,LOCATION_EXTRA,0,nil
	)
	if #g1==0 or #g2==0 then return end

	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g1:Select(tp,1,1,nil):GetFirst()
		if not sc then return end
		local mg=g2:Clone()
		if mg:IsContains(sc) then mg:RemoveCard(sc) end
		if #mg==0 then return end
		if Duel.GetLocationCountFromEx(tp,tp,nil,sc)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mat=mg:Select(tp,1,1,nil)
		if #mat==0 then return end
		if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			sc:SetMaterial(mat)
			Duel.Overlay(sc,mat)
			Duel.SpecialSummonComplete()
			sc:CompleteProcedure()
		end
	end
end
function s.mtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	end
end
function s.mop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0)
		or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
