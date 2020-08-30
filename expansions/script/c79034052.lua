--ULTRAMAN 奈克斯特
function c79034052.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79034052.ttcon)
	e1:SetOperation(c79034052.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c79034052.setcon)
	c:RegisterEffect(e2)
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c79034052.valcheck)
	c:RegisterEffect(e2)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa007))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)	
	--immune reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c79034052.regcon)
	e3:SetOperation(c79034052.regop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79034052)
	e4:SetTarget(c79034052.atktg)
	e4:SetOperation(c79034052.atkop)
	c:RegisterEffect(e4)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,790340529999)
	e5:SetCost(c79034052.cpcost)
	e5:SetTarget(c79034052.cptg)
	e5:SetOperation(c79034052.cpop)
	c:RegisterEffect(e5)
	if not c79034052.global_check then
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetLabel(0)
		ge1:SetOperation(c79034052.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c79034052.count=0
function c79034052.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSetCard,1,nil,0xa007) then
	e:GetHandler():RegisterFlagEffect(79034052,0,0,0)
	end
end
function c79034052.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c79034052.ttcon(e,c,minc)
	if c==nil then return true end
	return (minc<=3 and Duel.CheckTribute(c,3)) or Duel.CheckLPCost(tp,2000)
end
function c79034052.ttop(e,tp,eg,ep,ev,re,r,rp,minc)
	local c=e:GetHandler()
	local b1=Duel.CheckTribute(e:GetHandler(),3)
	local b2=Duel.CheckLPCost(tp,2000)
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79034052,0),aux.Stringid(79034052,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79034052,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79034052,1))+1
	end
	if op==0 then
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	else
	Duel.PayLPCost(tp,2000)
	end
end
function c79034052.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c79034052.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c79034052.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c79034052.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if bit.band(typ,TYPE_MONSTER)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,3))
	end
	if bit.band(typ,TYPE_SPELL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,4))
	end
	if bit.band(typ,TYPE_TRAP)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21377582,5))
	end
end
function c79034052.efilter(e,te)
	return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function c79034052.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(79034052)~=0 end
end
function c79034052.atkop(e,tp,eg,ep,ev,re,r,rp)
	local x=0
	if e:GetHandler():GetFlagEffect(79034052)==1 then
	x=1
	elseif e:GetHandler():GetFlagEffect(79034052)==2 then
	x=2
	elseif e:GetHandler():GetFlagEffect(79034052)==3 then
	x=3
	elseif e:GetHandler():GetFlagEffect(79034052)==4 then
	x=4
	elseif e:GetHandler():GetFlagEffect(79034052)==5 then
	x=5
	elseif e:GetHandler():GetFlagEffect(79034052)==6 then
	x=6
	elseif e:GetHandler():GetFlagEffect(79034052)==7 then
	x=7
	elseif e:GetHandler():GetFlagEffect(79034052)==8 then
	x=8
	elseif e:GetHandler():GetFlagEffect(79034052)==9 then
	x=9
	elseif e:GetHandler():GetFlagEffect(79034052)==10 then
	x=10
	elseif e:GetHandler():GetFlagEffect(79034052)==11 then
	x=11
	elseif e:GetHandler():GetFlagEffect(79034052)==12 then
	x=12
	elseif e:GetHandler():GetFlagEffect(79034052)==13 then
	x=13
	elseif e:GetHandler():GetFlagEffect(79034052)==14 then
	x=14
	elseif e:GetHandler():GetFlagEffect(79034052)==15 then
	x=15
	elseif e:GetHandler():GetFlagEffect(79034052)==16 then
	x=16
	elseif e:GetHandler():GetFlagEffect(79034052)==17 then
	x=17
	elseif e:GetHandler():GetFlagEffect(79034052)==18 then
	x=18
	elseif e:GetHandler():GetFlagEffect(79034052)==19 then
	x=19
	elseif e:GetHandler():GetFlagEffect(79034052)==20 then
	x=20
	elseif e:GetHandler():GetFlagEffect(79034052)==21 then
	x=21
	elseif e:GetHandler():GetFlagEffect(79034052)==22 then
	x=22
	elseif e:GetHandler():GetFlagEffect(79034052)==23 then
	x=23
	elseif e:GetHandler():GetFlagEffect(79034052)==24 then
	x=24
	elseif e:GetHandler():GetFlagEffect(79034052)==25 then
	x=25
	elseif e:GetHandler():GetFlagEffect(79034052)==26 then
	x=26
	elseif e:GetHandler():GetFlagEffect(79034052)==27 then
	x=27
	elseif e:GetHandler():GetFlagEffect(79034052)==28 then
	x=28
	elseif e:GetHandler():GetFlagEffect(79034052)==29 then
	x=29
	elseif e:GetHandler():GetFlagEffect(79034052)==30 then
	x=30
	elseif e:GetHandler():GetFlagEffect(79034052)==31 then
	x=31
	elseif e:GetHandler():GetFlagEffect(79034052)==32 then
	x=32
	elseif e:GetHandler():GetFlagEffect(79034052)==33 then
	x=33
	elseif e:GetHandler():GetFlagEffect(79034052)==34 then
	x=34
	elseif e:GetHandler():GetFlagEffect(79034052)==35 then
	x=35
	elseif e:GetHandler():GetFlagEffect(79034052)==36 then
	x=36
	elseif e:GetHandler():GetFlagEffect(79034052)==37 then
	x=37
	elseif e:GetHandler():GetFlagEffect(79034052)==38 then
	x=38
	elseif e:GetHandler():GetFlagEffect(79034052)==39 then
	x=39
	elseif e:GetHandler():GetFlagEffect(79034052)==40 then
	x=40
	else
	x=40
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(x*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2
)
end
function c79034052.cpfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSetCard(0xa007) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c79034052.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.GetTurnPlayer()~=tp end
end
function c79034052.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c79034052.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79034052.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c79034052.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end




