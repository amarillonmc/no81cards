local s,id,o=GetID()
function s.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	--become trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.repcon)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	--granted effect by field spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.grantcon)
	e3:SetCost(s.grantcost)
	e3:SetTarget(s.granttg)
	e3:SetOperation(s.grantop)
	c:RegisterEffect(e3)
end
function s.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x899) and c:IsControler(tp)
end
function s.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x899) then return false,nil end
	if lc:GetLink()==1 then return true,true end
	return true,not mg or mg:IsExists(s.mfilter,1,nil,tp)
end
function s.repcon(e)
	local c=e:GetHandler()
	return c:IsReason(REASON_LINK) and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function s.linkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x899) and c:IsType(TYPE_LINK)
end
function s.fieldfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x899) and c:IsType(TYPE_FIELD)
end
function s.grantcon(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)
		and Duel.IsExistingMatchingCard(s.linkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.fieldfilter,c:GetControler(),LOCATION_FZONE,0,1,nil)
end
function s.grantcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function s.posfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK) and c:IsCanTurnSet()
end
function s.granttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.grantop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
