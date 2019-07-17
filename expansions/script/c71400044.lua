--幻异梦物-猫
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400044.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400044,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c71400044.tg1)
	e1:SetOperation(c71400044.op1)
	c:RegisterEffect(e1)
end
function c71400044.filter1(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and not c:IsCode(71400044) and c:IsAbleToHand()
end
function c71400044.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400044.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400044.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400044.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE)
		e1:SetOperation(c71400044.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(0)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(c71400044.damcon)
		e2:SetOperation(c71400044.damop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function c71400044.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=1 and ep~=tp and (eg and eg:GetFirst():IsControler(tp) or re and re:GetHandlerPlayer()==tp) then
		e:SetLabel(1)
	end
end
function c71400044.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==0
end
function c71400044.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end