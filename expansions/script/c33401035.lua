--D.A.L 五河琴里
local m=33401035
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter1,cm.fusfilter2,cm.fusfilter2,cm.fusfilter2)
c:EnableReviveLimit()
		--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
--Destroy all
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
--sps
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCountLimit(1,m+10000)
	e8:SetTarget(cm.srtg)
	e8:SetOperation(cm.srop)
	c:RegisterEffect(e8)
 --Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.Eqop1)
	c:RegisterEffect(e4)
end
function cm.fusfilter1(c)
	return c:IsSetCard(0x9341) and c:GetOriginalAttribute()==ATTRIBUTE_FIRE and c:IsFusionType(TYPE_FUSION)
end
function cm.fusfilter2(c)
	return c:IsSetCard(0x9341)
end

function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,g,g:GetCount(),tp,g:GetCount()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,g,g:GetCount(),1-tp,g:GetCount()*500)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=g:GetCount()
	local ct2=0
	local ct3=0
	if ct>0 then
		 ct2=Duel.Destroy(g,REASON_EFFECT)
		 ct3=Duel.SendtoGrave(g,REASON_EFFECT) 
	end
	local ct4=ct2+ct3
	Duel.Damage(tp,500*ct4,REASON_EFFECT)
	Duel.Damage(1-tp,500*ct4,REASON_EFFECT)
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	 if g:GetCount()>0  then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ev)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsLocation(LOCATION_GRAVE)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_GRAVE)  then
			if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(tp,2000,REASON_EFFECT)
			--must attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		c:RegisterEffect(e1)
		end  
	end
end

function cm.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		cm.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,m+1)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(cm.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(cm.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--inm
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_SZONE)
			e3:SetLabelObject(ec)
			e3:SetCondition(cm.con3)
			e3:SetCountLimit(1)
			e3:SetOperation(cm.op3)
			token:RegisterEffect(e3)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function cm.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
 local tc=e:GetLabelObject()
	return  re:GetHandler()~=tc
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)   
	  local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_RECOVER)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DAMAGE)
		e2:SetReset(RESET_PHASE+Duel.GetCurrentPhase())
		e2:SetCondition(cm.con11)
		e2:SetOperation(cm.op11)
		Duel.RegisterEffect(e2,tp)
end
function cm.con11(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and ep==tp
end
function cm.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end