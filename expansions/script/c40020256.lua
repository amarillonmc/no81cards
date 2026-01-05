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
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id) 
	e1:SetCondition(s.chcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.atkcon)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100) 
	e3:SetTarget(s.mtg1)
	e3:SetOperation(s.mop1)
	c:RegisterEffect(e3)
end

function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function s.xyzfilter(c,e,tp)
	return s.AwakenedDragon(c) and c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.matfilter(c)
	return s.AwakenedDragon(c) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		   and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local matg=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_EXTRA,0,1,1,sc)
		local mc=matg:GetFirst()
		
		if mc then
			sc:SetMaterial(Group.FromCards(mc))
			if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
				Duel.Overlay(sc,mc)
				sc:CompleteProcedure()
			end
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
