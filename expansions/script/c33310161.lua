--临魔终形
function c33310161.initial_effect(c)
	 --xyz summon
	--aux.AddXyzProcedure(c,aux.TRUE,12,3,c33310161.ovfilter,aux.Stringid(33310161,0))
	aux.AddXyzProcedure(c,nil,12,3,c33310161.ovfilter,aux.Stringid(33310161,0),2)
	c:EnableReviveLimit()
	--over
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c33310161.ovcondition)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c33310161.ovop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33310161.cost)
	e2:SetOperation(c33310161.op)
	c:RegisterEffect(e2)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c33310161.imcon)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_REMOVE)
	e9:SetCondition(c33310161.imcon2)
	c:RegisterEffect(e9)
end
function c33310161.imconfil(c)
	return c:IsFaceup() and c:IsSetCard(0x55b)
end
function c33310161.imcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c33310161.imconfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c33310161.imcon2(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c33310161.imconfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetReasonPlayer()~=tp
end
function c33310161.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x55b) and c:GetOverlayCount()>=5 and c:IsType(TYPE_XYZ)
end

function c33310161.ovcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33310161.ovopfil,1,nil,tp)
end
function c33310161.ovopfil(c,tp)
	return c:GetPreviousControler()==1-tp
end
function c33310161.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33310161.ovopfil,nil,tp)
	if e:GetHandler():IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(33310161,1)) then 
	 local tc=g:GetFirst()
		   while tc do
			if tc:IsType(TYPE_TOKEN) then
			   RemoveCard(g,tc)
			end
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		   tc=g:GetNext()
		   end
		Duel.Overlay(e:GetHandler(),g)
	end
end

function c33310161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:IsExists(Card.IsAbleToRemoveAsCost,1,nil)   end
	local g=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,99,nil)
	local num=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(num)
end
function c33310161.spfil(c,e,tp,num)
	return (c:IsLevelBelow(num) or c:IsRankBelow(num)) and c:IsSetCard(0x55b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33310161.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetLabel()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(num*100)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c33310161.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,num) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(33310161,2)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c33310161.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,num)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end