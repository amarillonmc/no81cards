--炼金工房小学者 塔奥·蒙伽特恩
function c75011018.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c75011018.xyzlv)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75011018,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,75011018)
	e2:SetCondition(c75011018.thcon)
	e2:SetCost(c75011018.thcost)
	e2:SetTarget(c75011018.thtg)
	e2:SetOperation(c75011018.thop)
	c:RegisterEffect(e2)
end
function c75011018.xyzlv(e,c,rc)
	if rc:IsSetCard(0x75e) then
		return c:GetLevel()+0x50000
	else
		return c:GetLevel()
	end
end
function c75011018.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and rp==tp
end
function c75011018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
		e:SetLabel(2)
	else
		e:SetLabel(1)
	end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75011018.thfilter(c)
	return c:IsCode(46130346,5318639) and c:IsAbleToHand()
end
function c75011018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011018.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c75011018.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75011018.thfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetLabel()
	if ct~=2 then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
