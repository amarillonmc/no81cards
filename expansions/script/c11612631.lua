--龙仪巧-天蝎流星＝SCO
local m=11612631
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_tx
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e00=fpjdiy.Zhc(c,cm.text)
	--  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_MUST_ATTACK)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e12)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m*2+1)
	e4:SetCode(EVENT_RELEASE)
	e4:SetTarget(cm.detg)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e5)
end
--0
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--
--1
--2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then
			tc:AddCounter(0x1161,1,REASON_EFFECT)
			cm.counter(tc,c)			
		end
		tc=eg:GetNext()
	end
end
function cm.counter(tc,ec)
	--tc:AddCounter(0x1161,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	--e1:SetCondition(cm.atkcon)
	e1:SetValue(cm.atkva)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
   -- local e2=e1:Clone()
	--e2:SetCode(EFFECT_UPDATE_DEFENSE)
	--tc:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(ec)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(cm.descon)
	tc:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(ec)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(cm.condition)
	e4:SetOperation(cm.mtop)
	tc:RegisterEffect(e4)
end
--function cm.atkcon(e)
  --  return e:GetHandler():GetCounter(0x12c3)>0
--end
function cm.atkva(e)
	local ct=e:GetHandler():GetCounter(0x1161)
	return ct*(-400)
end
function cm.descon(e)
	local c=e:GetHandler()
	return c:IsAttack(0)
end
function cm.desfilter(c)
	return c:GetCounter(0x1161)>0
end
function cm.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 and not Duel.CheckPhaseActivity() and c:GetCounter(0x1161)>0
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message('你已无药可救')
	local c=e:GetHandler()
	if c:GetCounter(0x1161)<=0 then return end
	c:AddCounter(0x1161,1,REASON_EFFECT)
	local seq=c:GetSequence()
	local dg=Duel.GetMatchingGroup(cm.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,c:GetControler())
	if seq<5 and dg:GetCount()>0 then	 
		local dgc=dg:GetFirst()
		while dgc do
			if dgc:GetCounter(0x1161)<=0 then
				cm.counter(dgc,c)
			end
			dgc:AddCounter(0x1161,1,REASON_EFFECT)
			dgc=dg:GetNext()
		end
	end
end
--03
function cm.thfilter(c)
	return c:IsSetCard(0x154) and c:IsAbleToHand()
end
function cm.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
