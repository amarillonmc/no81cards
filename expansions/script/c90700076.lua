local m=90700076
local cm=_G["c"..m]
cm.name="“真现实"
function cm.initial_effect(c)
	cm.fake_ini_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(0x1ff)
	e1:SetCondition(cm.wincon)
	e1:SetOperation(cm.winop)
  --  c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop_1)
  --  c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetOperation(cm.actop_2)
  --  c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
  --  c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.adval)
  --  c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
  --  c:RegisterEffect(e6)
	local func,mark,count=debug.gethook()
	if func==cm.hook_func then return end
	for tc in aux.Next(Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)) do
		local code_1=tc:GetOriginalCode()
		local code_2=tc:GetOriginalCodeRule()
		_G["c"..code_1].initial_effect=cm.fake_ini_effect
		if code_2 then
			_G["c"..code_2].initial_effect=cm.fake_ini_effect
		end
		Card.ReplaceEffect(tc,90700077,nil)
		cm.fake_ini_effect(tc)
	end
	debug.sethook(cm.hook_func,'l')
end
function cm.hook_func()
	local tb=debug.getinfo(2)
	if tb.linedefined==0 then
		local code=string.sub(tb.source,11,-5)
		_G["c"..code].initial_effect=cm.fake_ini_effect
	end
end
function cm.fake_ini_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.stcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REVERSE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.revdam)
	c:RegisterEffect(e3)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return c:IsType(TYPE_SPSUMMON+TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and Duel.GetActivityCount(c:GetControler(),ACTIVITY_NORMALSUMMON)==0 and (not c:IsType(TYPE_PENDULUM) or c:IsPosition(POS_FACEDOWN))
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
function cm.revdam(e,re,r,rp,rc)
	local c=e:GetHandler()
	return bit.band(r,REASON_BATTLE)~=0 and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local winmessage = 0x4
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
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Duel.Hint(HINT_CARD,nil,m)
	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())
end
function cm.actop_1(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.AnnounceCard(tp)
	local tk=Duel.CreateToken(tp,code)
	Card.ReplaceEffect(tk,90700077,nil)
	cm.fake_ini_effect(tk)
	local op_1=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	local op_2=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
	if op_1==0 then
		if op_2==0 then
			Duel.SendtoHand(tk,tp,nil)
		end
		if op_2==1 then
			Duel.SendtoDeck(tk,tp,2,nil)
		end
	end
	if op_1==1 then
		if op_2==0 then
			Duel.SendtoHand(tk,1-tp,nil)
		end
		if op_2==1 then
			Duel.SendtoDeck(tk,1-tp,2,nil)
		end
	end
end
function cm.actop_2(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(m,6),aux.Stringid(m,7))
	local p
	if op==0 then p=tp end
	if op==1 then p=1-tp end
	local max=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	local list={}
	local i=0
	while i<=max do
		table.insert(list,i)
		i=i+1
	end
	local num,seq=Duel.AnnounceNumber(tp,table.unpack(list))
	Duel.DiscardDeck(p,num,nil)
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