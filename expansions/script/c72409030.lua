--神造遗物使 莲夜
function c72409030.initial_effect(c)
	aux.EnableDualAttribute(c)
	--to grave/search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72409030,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,72409030)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c72409030.tgtg)
	e1:SetOperation(c72409030.tgop)
	c:RegisterEffect(e1)
end
function c72409030.eqfilter(c,e,tp)
	return c:IsType(TYPE_EQUIP)  and c:CheckEquipTarget(e:GetOwner()) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c72409030.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72409030.eqfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c72409030.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c72409030.eqfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Equip(tp,g:GetFirst(),e:GetOwner()) 
end