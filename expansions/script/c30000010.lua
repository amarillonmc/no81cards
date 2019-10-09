--终焉邪魂 毁灭魔主萨洛蒙
function c30000010.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3920),2)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x920))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(30000010)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,30000010)
	e4:SetTarget(c30000010.thtg)
	e4:SetOperation(c30000010.thop)
	c:RegisterEffect(e4)
end
function c30000010.thfil(c)
	return c:IsSetCard(0x920) and c:IsFaceup() and c:IsAbleToHand()
end
function c30000010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000010.thfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c30000010.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c30000010.thfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c30000010.thfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.IsPlayerCanDraw(p,tp,1) and Duel.SelectYesNo(tp,aux.Stringid(30000010,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end