--幻日女之御巫
function c62501311.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x18d),nil,nil,aux.NonTuner(Card.IsSetCard,0x18d),1,1)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--reflect battle damage
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501311,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,62501311)
	e3:SetTarget(c62501311.thtg)
	e3:SetOperation(c62501311.thop)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetDescription(aux.Stringid(62501311,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,62501311+1)
	e4:SetTarget(c62501311.eqtg)
	e4:SetOperation(c62501311.eqop)
	c:RegisterEffect(e4)
end
function c62501311.desfilter(c)
	return (c:GetType()&TYPE_EQUIP+TYPE_SPELL)==TYPE_EQUIP+TYPE_SPELL and c:IsFaceup()
end
function c62501311.thfilter(c,chk)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c62501311.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501311.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.IsExistingMatchingCard(c62501311.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c62501311.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c62501311.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501311.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c62501311.eqfilter(c)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c62501311.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501311.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c62501311.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c62501311.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not ec then return end
	Duel.HintSelection(Group.FromCards(ec))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ec):GetFirst()
	if not Duel.Equip(tp,ec,tc,false) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetLabelObject(tc)
	e1:SetValue(c62501311.eqlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e1)
end
function c62501311.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==e:GetLabelObject()
end
