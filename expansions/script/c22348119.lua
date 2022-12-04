--妒 之 妖 水 桥 帕 露 西 
local m=22348119
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c22348119.ovfilter,aux.Stringid(22348119,0),99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348119,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetCode(EVENT_DETACH_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c22348119.atktg)
	e1:SetOperation(c22348119.atkop)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348119,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c22348119.xyzcon)
	e2:SetOperation(c22348119.xyzop)
	c:RegisterEffect(e2)
end
function c22348119.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x704) and c:IsLevel(4)
end
function c22348119.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c22348119.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Group.CreateGroup()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	local aa=math.abs(tc:GetAttack()-c:GetAttack())
	local ttc=tg:GetFirst()
	while ttc do
		local preatk=ttc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-aa)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ttc:RegisterEffect(e1)
		if preatk~=0 and ttc:IsAttack(0) then dg:AddCard(ttc) end
		ttc=tg:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c22348119.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local htp1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local htp2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local aa=math.abs(htp1-htp2)
	return c:IsPreviousLocation(LOCATION_OVERLAY) and 0<aa
end

function c22348119.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c22348119.xyzcon1)
	e1:SetTarget(c22348119.xyztg1)
	e1:SetOperation(c22348119.xyzop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348119.xyzfilter1(c,tp)
	return c:IsControler(tp)
end
function c22348119.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
	local htp1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local htp2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	local aa=math.abs(htp1-htp2)
	return eg:IsExists(c22348119.xyzfilter1,1,nil,1-tp) and Duel.GetFlagEffect(tp,22348119)<aa
end
function c22348119.xyzfilter2(c)
	return c:IsSetCard(0x704) and c:IsSpecialSummonable()
end
function c22348119.xyztg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348119.xyzfilter2,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c22348119.xyzop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(22348119,2)) then
	Duel.RegisterFlagEffect(tp,22348119,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,22348119)
	local g=Duel.GetMatchingGroup(c22348119.xyzfilter2,tp,LOCATION_EXTRA+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
	end
end



















