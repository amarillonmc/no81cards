--天使-刻刻帝
function c33400113.initial_effect(c)
	c:SetUniqueOnField(1,0,33400113)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune effect   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE+LOCATION_FZONE,0)
	e2:SetCondition(c33400113.condition)
	e2:SetTarget(c33400113.etarget)
	e2:SetValue(c33400113.efilter)
	c:RegisterEffect(e2)
	--to hand   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400113,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCountLimit(1,33400113)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33400113.thcon)
	e3:SetTarget(c33400113.thtg)
	e3:SetOperation(c33400113.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
end
function c33400113.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re  and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x3340) and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end
function c33400113.thfilter(c,rc)
	return c:IsSetCard(0x3340) and c:IsType(TYPE_QUICKPLAY) and  not c:IsCode(rc:GetCode()) and c:IsAbleToHand()
end
function c33400113.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc and Duel.IsExistingMatchingCard(c33400113.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,rc) 
	end
	e:SetLabelObject(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33400113.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400113.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33400113.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c33400113.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33400113.cfilter(c)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c33400113.etarget(e,c)
	return c:IsCode(33400113) or c:IsCode(33400100)
end
function c33400113.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end