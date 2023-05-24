--幻异梦境-梦海底
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400070.initial_effect(c)
	--same effect send this card to grave and spsummon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--Activate
	--See AddYumeFieldGlobal
	--change attribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400070,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,71400070)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c71400070.op1)
	c:RegisterEffect(e1)
	--activate field
	yume.AddYumeFieldGlobal(c,71400070,1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400070,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71500070)
	e3:SetLabelObject(e0)
	e3:SetCondition(c71400070.con3)
	e3:SetCost(c71400070.cost3)
	e3:SetTarget(c71400070.tg3)
	e3:SetOperation(c71400070.op3)
	c:RegisterEffect(e3)
end
function c71400070.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WATER)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e1g=e1:Clone()
	e1g:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e1g:SetCondition(c71400070.gravecon)
	Duel.RegisterEffect(e1g,tp)
end
function c71400070.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c71400070.filtercon3(c,se)
	return c:IsFaceup() and c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and (se==nil or c:GetReasonEffect()~=se)
end
function c71400070.con3(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c71400070.filtercon3,1,nil,se)
end
function c71400070.filterc3(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsAbleToDeckAsCost()
end
function c71400070.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400070.filterc3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71400070.filterc3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c71400070.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x714) and c:IsAbleToGrave()
end
function c71400070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400070.filter3,tp,LOCATION_DECK,0,1,nil) and yume.IsYumeFieldOnField(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71400070.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c71400070.filter3,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>2 then ct=2 end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end