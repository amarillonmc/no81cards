--卓越创造物Ω
byd=byd or {}
byd.loaded_metatable_list={}

local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	
	byd.GArtifact(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLP(tp)<8000 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<8000 then Duel.SetLP(tp,8000) end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local dg=Group.CreateGroup()
		for tc in aux.Next(g) do
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and (tc:IsAttack(0) or tc:IsDefense(0)) then dg:AddCard(tc) end
		end
		if #dg~=0 then Duel.Destroy(dg,REASON_EFFECT) end
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function byd.GArtifact(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(byd.spcon)
	e2:SetTarget(byd.sptg)
	e2:SetOperation(byd.spop)
	c:RegisterEffect(e2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(byd.rcon)
	e1:SetOperation(byd.rop)
	c:RegisterEffect(e1)
	
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_HAND+LOCATION_DECK)
	e3:SetOperation(byd.checkop)
	c:RegisterEffect(e3)
end
function byd.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(byd.spfil,tp,LOCATION_MZONE,0,1,c) and Duel.GetFlagEffect(tp,60001511)~=0
end
function byd.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(byd.spfil,tp,LOCATION_MZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function byd.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function byd.spfil(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsReleasable()
end
function byd.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToRemove()
end
function byd.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	Duel.Readjust()
end
function byd.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=1 then return end
	if not byd.SpaceCheck then
		byd.SpaceCheck=1
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK,0,nil)>=60 then
			Duel.RegisterFlagEffect(tp,60001511,0,0,1)
		end
	end
	if Duel.GetFlagEffect(tp,60001511)~=0 and Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_RULE)~=0 and e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end