--Proto-Summonknight 瑚太朗
function c33700033.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3440),2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(0x3440)
	c:RegisterEffect(e1)  
   --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_FUSION)
	e2:SetCondition(c33700033.sprcon)
	e2:SetOperation(c33700033.sprop)
	c:RegisterEffect(e2)   
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c33700033.intg)
	e3:SetValue(c33700033.efilter)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetTarget(c33700033.pentg)
	e4:SetOperation(c33700033.penop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c33700033.desreptg)
	c:RegisterEffect(e5)
end
function c33700033.spfilter(c)
	return c:IsFusionSetCard(0x3440) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckAsCost() and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c33700033.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33700033.spfilter,tp,LOCATION_EXTRA,0,2,nil)
end
function c33700033.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33700033.spfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	local tc=g:GetFirst()
	while tc do
	   Duel.ConfirmCards(1-tp,tc)
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33700033.intg(e,c)
	return c:IsSetCard(0x3440) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(6440))
end
function c33700033.efilter(e,re,rp,c)
	return re:GetOwner()~=c
end

function c33700033.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>0 end
end
function c33700033.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)<=0 then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c33700033.filter(c)
	return  c:IsFaceup() and  c:IsSetCard(0x6440) and c:IsReleasableByEffect() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c33700033.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_EFFECT)
		and Duel.CheckReleaseGroup(PLAYER_ALL,c33700033.filter,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(33700000,1)) then
		local g=Duel.SelectMatchingCard(tp,c33700033.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
