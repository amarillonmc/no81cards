--星贯千魂 罗慕路斯·奎里努斯
function c22024540.initial_effect(c)
	c:SetUniqueOnField(1,1,22024540)
	--link summon
	aux.AddLinkProcedure(c,nil,7,7)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c22024540.matval)
	c:RegisterEffect(e1)
	--Add
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetCondition(c22024540.tgcon)
	e2:SetTarget(c22024540.eftg)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024540,0))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22024540.cttg)
	e3:SetOperation(c22024540.ctop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	--e4:SetCondition(c22024540.tgcon)
	e4:SetTarget(c22024540.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetDescription(aux.Stringid(22024540,1))
	e5:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c22024540.damcon)
	e5:SetTarget(c22024540.cttg)
	e5:SetOperation(c22024540.ctop1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	--e6:SetCondition(c22024540.tgcon)
	e6:SetTarget(c22024540.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--Discard
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22024540,2))
	e7:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,22024540+EFFECT_COUNT_CODE_DUEL)
	e7:SetCondition(c22024540.hdcon)
	e7:SetTarget(c22024540.hdtg)
	e7:SetOperation(c22024540.hdop)
	c:RegisterEffect(e7)
	--Discard ere
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22024540,3))
	e8:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,22024540+EFFECT_COUNT_CODE_DUEL)
	e8:SetCondition(c22024540.erecon)
	e8:SetCost(c22024540.erecost)
	e8:SetTarget(c22024540.hdtg)
	e8:SetOperation(c22024540.hdop)
	c:RegisterEffect(e8)

	if not c22024540.global_flag then
		c22024540.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22024540.regop1)
		Duel.RegisterEffect(ge1,0)
	end
end
c22024540.toss_coin=true
function c22024540.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(22024540) then return false end
	end
	return true  
end
function c22024540.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c22024540.exmatcheck,1,nil,lc,tp)
end
function c22024540.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22024540.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function c22024540.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
end
function c22024540.ctop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2==0 then
	end
	if c1+c2>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if c1+c2==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22024540.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22024540.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2==0 and c:IsRelateToBattle() and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

function c22024540.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
			Duel.RegisterFlagEffect(tp,22024540,RESET_PHASE+PHASE_END,0,1)
	end
end
function c22024540.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22024540)>6
end
function c22024540.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,7000)
end
function c22024540.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	Duel.Damage(1-tp,7000,REASON_EFFECT)
end
function c22024540.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22024540)>6 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024540.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end