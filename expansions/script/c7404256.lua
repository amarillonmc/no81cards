--提斯蒂娜之晶神
local s,id,o=GetID()
function s.initial_effect(c)
	--tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--tohand (self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	--summon proc
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e5:SetCondition(s.sumcon)
	e5:SetOperation(s.sumop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	e5:SetReset(EVENT_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function s.exfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1a4) and c:IsAbleToGrave()
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and mi>0 and Duel.GetMatchingGroupCount(s.exfilter,c:GetControler(),LOCATION_DECK,0,nil)>=1 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi or mi<=0 then return false end
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK,0,1,1,nil)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_SUMMON+REASON_MATERIAL)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
