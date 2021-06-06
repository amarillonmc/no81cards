--东国·近卫干员-赤冬
function c79029467.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029467+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029467.hspcon)
	e1:SetOperation(c79029467.hspop)
	e1:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e1)
	--immuse
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c79029467.condition)
	e2:SetOperation(c79029467.operation)
	c:RegisterEffect(e2) 
	--   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
		if not c79029467.global_check then
		c79029467.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_NEGATED)
		ge1:SetCountLimit(1,29029467)
		ge1:SetCondition(c79029467.checkcon)
		ge1:SetOperation(c79029467.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_NEGATED)
		ge1:SetCountLimit(1,39029467)
		ge1:SetCondition(c79029467.checkcon)
		ge1:SetOperation(c79029467.checkop)
		Duel.RegisterEffect(ge1,0)
end  
end
function c79029467.ckfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:GetSummonPlayer()==tp
end
function c79029467.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c79029467.ckfil,nil,e,tp):GetCount()>0
end
function c79029467.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029467)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029467,flag+1)
	else
	Debug.Message("快点出发，刀都快锈了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029467,1))
	Duel.RegisterFlagEffect(xp,79029467,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029467.spfilter(c,ft)
	return c:IsAbleToDeckAsCost() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029467.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c79029467.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,79029467)~=0 
end
function c79029467.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029467.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,ft)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Debug.Message("现在，出击！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029467,2))
end
function c79029467.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function c79029467.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("不管是谁，都将被我斩杀于刀下！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029467,3))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetAttack()*2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(c:GetDefense()*2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029467,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetValue(c79029467.efilter)
	e3:SetOwnerPlayer(tp)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
end
function c79029467.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end








