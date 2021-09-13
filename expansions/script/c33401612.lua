--被缚之观测者 万由里
local m=33401612
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
XY.mayuri(c)
	--link summon
	 aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,m)
	e7:SetCondition(cm.thcon)
	e7:SetTarget(cm.thtg)
	e7:SetOperation(cm.thop)
	c:RegisterEffect(e7)
 if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.matfilter(c)
	return  c:IsLinkType(TYPE_MONSTER) and c:IsSetCard(0x6344)
end

function cm.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local sg=eg:Filter(cm.cfilter,nil,tp)
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000-RESET_TOGRAVE,0,1)
		tc=sg:GetNext()
	end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tffilter(c,tp)
	return  c:IsCode(33401625)  and not c:IsForbidden() and c:CheckUniqueOnField(tp) 
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		local ss=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	   if ss==0 then 
		 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(cm.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	   end
	   if ss==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(cm.tg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		Duel.RegisterEffect(e1,1-tp)
	   end

	end
end
function cm.atktg(e,c)
	return c:IsFaceup()
end
function cm.tg(e,c)
	return c:IsFaceup() and c:GetFlagEffect(m)==0
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:GetHandler():IsType(TYPE_MONSTER)
end