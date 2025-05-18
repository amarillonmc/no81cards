--齐驱之刃 影潜者 奥纽克斯
function c40011516.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c40011516.transcon)
	e2:SetOperation(c40011516.transop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40011516)
	e3:SetTarget(c40011516.settg)
	e3:SetOperation(c40011516.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c40011516.setfilter(c)
	return c:IsSetCard(0xaf1b) and not c:IsCode(40011516) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40011516.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011516.setfilter,tp,LOCATION_DECK,0,1,nil) end 
end
function c40011516.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c40011516.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(TYPE_TRAP)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c40011516.transcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==40011516 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c40011516.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(9911633,true)
	c:ReplaceEffect(9911633,0,0)
end
