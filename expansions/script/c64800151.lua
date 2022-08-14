--燃煤概念机 瓦特
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	RMJ_02.des1(c,id)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id+20000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e3:SetCost(s.tkcost)
	e3:SetTarget(s.tktg)
	e3:SetOperation(s.tkop)
	c:RegisterEffect(e3)
end

--e1e2
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local g1=Duel.GetMatchingGroup(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<=0
		or Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end

--e3
function s.rmf1(c)
	return RMJ_02.rmf(c) and Duel.IsExistingMatchingCard(s.rmf2,tp,LOCATION_EXTRA,0,1,c,c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function s.rmf2(c,lv,ra,att)
	return RMJ_02.rmf(c) and c:IsLevel(lv) and c:IsRace(ra) and c:IsAttribute(att)
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmf1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmf1,tp,LOCATION_EXTRA,0,1,1,nil)  
	local tc=g:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,s.rmf2,tp,LOCATION_EXTRA,0,1,1,tc,tc:GetLevel(),tc:GetRace(),tc:GetAttribute())
	g:Merge(g2)
	e:SetLabel(tc:GetLevel(),tc:GetRace(),tc:GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x,y,z=e:GetLabel()
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,64800161,0x541a,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),x,y,z) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local x,y,z=e:GetLabel()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,64800161,0x541a,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),x,y,z) then return end
	local token=Duel.CreateToken(tp,64800161)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c:GetDefense())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(c:GetAttack())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(z)
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(x)
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_RACE)
		e5:SetValue(y)
		token:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_ADD_TYPE)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetValue(TYPE_TUNER)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
	end
end