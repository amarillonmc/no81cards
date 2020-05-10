--降临者·杨贵妃
function c9950943.initial_effect(c)
	  --ritual summon
	local e1=aux.AddRitualProcGreater2(c,c9950943.filter,LOCATION_HAND+LOCATION_DECK,nil,c9950943.matfilter)
	e1:SetDescription(aux.Stringid(9950943,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c9950943.rscost)
	  --become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c9950943.condition)
	e2:SetOperation(c9950943.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9950943)
	e3:SetTarget(c9950943.thtg)
	e3:SetOperation(c9950943.thop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950943.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950943.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950943,0))
end
function c9950943.filter(c,e,tp,chk)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_RITUAL) and (not chk or c~=e:GetHandler())
end
function c9950943.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c9950943.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9950943.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c9950943.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(9950943)==0 then
			--untargetable
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(9950943,1))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetLabel(ep)
			e1:SetTargetRange(0,1)
			e1:SetValue(c9950943.aclimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetAbsoluteRange(ep,0,1)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(9950943,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end
function c9950943.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
end
function c9950943.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950943.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950943.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950943.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950943.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950943,0))
end