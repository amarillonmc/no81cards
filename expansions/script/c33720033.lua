--Ricolamal, The Raging Justice
--Scripted by:XGlitchy30
local id=33720033
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--selfspin
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.adjustop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2x)
	--cannot use as material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(s.limit)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3x)
	local e3y=e3:Clone()
	e3y:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3y)
	local e3z=e3:Clone()
	e3z:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e3z)
	--lose ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	local e4x=e4:Clone()
	e4x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4x)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e5)
	--protection
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e6x=e6:Clone()
	e6x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6x)
	--pierce
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetCondition(s.nhcon)
	e7:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e7)
	--check draw
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_TO_HAND)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.cdcon1)
	e8:SetOperation(s.cdop1)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetCode(EVENT_TO_HAND)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.regcon)
	e9:SetOperation(s.regop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e10:SetCode(EVENT_CHAIN_SOLVED)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(s.cdcon2)
	e10:SetOperation(s.cdop2)
	c:RegisterEffect(e10)
	--
	e9:SetLabelObject(e10)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsAbleToDeck() then return end
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if Duel.GetLP(tp)>Duel.GetLP(1-tp) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		if e:GetHandler():IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(e:GetHandlerPlayer())
		end
		Duel.Readjust()
	end
end
--
function s.limit(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA)
end
--
function s.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))*-1
end
function s.nhcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
end
--
function s.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.cdcon1(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:IsExists(s.cfilter,1,nil,tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.cdop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=eg:GetFirst()
	if not tc or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,eg)
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		if Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEUP)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetLP(tp)<=1000 then
			local dam=tc:GetBaseAttack()
			if dam<0 then dam=0 end
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
	eg:DeleteGroup()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,id)==0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	e:GetLabelObject():SetLabelObject(eg)
	eg:KeepAlive()
end
function s.cdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.cdop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	if e:GetLabelObject() then
		s.cdop1(e,tp,e:GetLabelObject(),ep,ev,re,r,rp)
		e:GetLabelObject():DeleteGroup()
	end
end
