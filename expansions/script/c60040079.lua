--收获的参谋长·喵鲁
local cm,m,o=GetID()
function cm.initial_effect(c)
	--code
	aux.EnableChangeCode(c,60040069,LOCATION_MZONE+LOCATION_GRAVE)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.indtg(e,c)
	return c:IsCode(60040052) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ntlfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.ntlfil(c)
	return c:IsSetCard(0x644) and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ntlfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(cm.ntlfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local a=0
	local b=0
	local c=0
	local i=1
	while num~=0 do
		if i==1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(800)
			e:GetHandler():RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(800)
			e:GetHandler():RegisterEffect(e1)
			i=i+1
		elseif i==2 then
			Duel.Recover(tp,400,REASON_EFFECT)
			Duel.Damage(1-tp,400,REASON_EFFECT)
			i=i+1
		elseif i==3 then
			Duel.Draw(tp,1,REASON_EFFECT)
			i=1
		end
		num=num-1
	end
end