--伯吉斯异兽·伯格美杜莎水母
local s,id,o=GetID()
function c98921041.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,s.matfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921041,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98921041)
	e3:SetTarget(c98921041.destg)
	e3:SetOperation(c98921041.desop)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98921041,0))
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetCondition(c98921041.rmcon)
	e4:SetTarget(c98921041.target)
	e4:SetOperation(c98921041.operation)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return c:IsFusionSetCard(0xd4) and not c:IsType(TYPE_XYZ)
end
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c98921041.desfilter(c)
	return not c:IsLocation(LOCATION_FZONE)
end
function c98921041.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c98921041.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921041.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98921041.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98921041.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if not (tc:IsLocation(LOCATION_HAND+LOCATION_DECK) or tc:IsLocation(LOCATION_REMOVED) and tc:IsFacedown()) and Duel.IsPlayerCanSpecialSummonMonster(tp,98921041,0,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) and Duel.SelectYesNo(tp,aux.Stringid(98921041,1)) then
		   tc:AddMonsterAttribute(TYPE_NORMAL)
		   Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_CHANGE_LEVEL)
		   e1:SetValue(2)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1,true)
		   local e2=Effect.CreateEffect(tc)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_IMMUNE_EFFECT)
		   e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		   e2:SetRange(LOCATION_MZONE)
		   e2:SetValue(c98921041.efilter2)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e2)
		   local e3=Effect.CreateEffect(tc)
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		   e3:SetValue(LOCATION_REMOVED)
		   tc:RegisterEffect(e3,true)
		   local e4=Effect.CreateEffect(tc)
		   e4:SetType(EFFECT_TYPE_SINGLE)
		   e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		   e4:SetValue(ATTRIBUTE_WATER)
		   e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e4,true)
		   local e5=e4:Clone()
		   e5:SetCode(EFFECT_CHANGE_RACE)
		   e5:SetValue(RACE_AQUA)
		   tc:RegisterEffect(e5,true)
		   local e6=e4:Clone()
		   e6:SetCode(EFFECT_SET_BASE_ATTACK)
		   e6:SetValue(1200)
		   tc:RegisterEffect(e6,true)
		   local e7=e6:Clone()
		   e7:SetCode(EFFECT_SET_BASE_DEFENSE)
		   e7:SetValue(0)
		   tc:RegisterEffect(e7,true)
		   Duel.SpecialSummonComplete()
		end
	end
end
function c98921041.efilter2(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function c98921041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and tc:IsCanOverlay() end
end
function c98921041.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c98921041.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c:IsRace(RACE_AQUA) and c:IsType(TYPE_XYZ) and bc and bc:IsRelateToBattle()
end