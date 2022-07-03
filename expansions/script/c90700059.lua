local m=90700059
local cm=_G["c"..m]
cm.name="转生之真现实"
c90700077={}
function c90700077.initial_effect(c) end
function cm.initial_effect(c)
	cm.fake_ini_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.wincon)
	e1:SetOperation(cm.winop)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.revdam)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetOperation(cm.realop)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	Duel.RegisterEffect(e3,0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.adval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e6)
end
function cm.fake_ini_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.stcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local con1=c:IsType(TYPE_SPSUMMON+TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	local con2=Duel.GetActivityCount(c:GetControler(),ACTIVITY_NORMALSUMMON)==0
	local con3=not c:IsType(TYPE_PENDULUM) or c:IsPosition(POS_FACEDOWN)
	return con1 and con2 and con3
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function cm.adval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsPosition,0,LOCATION_MZONE,LOCATION_MZONE,nil,POS_FACEUP)
	g:Sub(g:Filter(Card.IsCode,nil,m))
	if g:GetCount()==0 then
		return 100
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+100
	end
end
function cm.revdam(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)~=0
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local winmessage=0x4
	local lp0=Duel.GetLP(0)
	local lp1=Duel.GetLP(1)
	if lp0>lp1 then
		Duel.Win(1,winmessage)
	elseif lp0<lp1 then
		Duel.Win(0,winmessage)
	elseif lp0==lp1 then
		Duel.Win(PLAYER_NONE,winmessage)
	end
end
function cm.realop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,0,0x1ff,0x1ff,nil)
	g:ForEach(
		function(tc)
			if tc:IsCode(90700059) then return end
			Card.ReplaceEffect(tc,90700077,nil)
			cm.fake_ini_effect(tc)
		end
	)
end