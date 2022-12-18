--战车道装甲·MK.Ⅳ
require("expansions/script/c9910106")
function c9910161.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,nil,7,2,c9910161.xyzfilter,aux.Stringid(9910161,0),99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910161,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9910161.imtg)
	e1:SetOperation(c9910161.imop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910161,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9910161.rmcon)
	e2:SetTarget(c9910161.rmtg)
	e2:SetOperation(c9910161.rmop)
	c:RegisterEffect(e2)
end
function c9910161.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
end
function c9910161.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910161.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910161.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9910161.xfilter,tp,LOCATION_MZONE,0,1,c)
		and (c:IsCanOverlay() or c:GetOverlayCount()>0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910161.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c9910161.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Group.FromCards(c)
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then g:Merge(og) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910161,2))
		local sg=g:Select(tp,1,1,nil)
		if sg:IsContains(c) then
			if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
		else
			Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
		Duel.Overlay(tc,sg)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c9910161.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
		and rp==1-tp and c:GetPreviousControler()==tp
end
function c9910161.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9910161.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
