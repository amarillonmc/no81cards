--真红眼刻蚀龙
function c10150046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c10150046.ovfilter,aux.Stringid(10150046,0),2,c10150046.xyzop)
	c:EnableReviveLimit()
	--mat
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150046,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10150046.mattg)
	e1:SetOperation(c10150046.matop)
	c:RegisterEffect(e1)
	--mat 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150046,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c10150046.matcost)
	e2:SetCondition(c10150046.matcon2)
	e2:SetTarget(c10150046.mattg2)
	e2:SetOperation(c10150046.matop2)
	c:RegisterEffect(e2)
end
function c10150046.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c10150046.matcon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c10150046.mfilter(c,tp)
	return c:IsFaceup() and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c10150046.mattg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c10150046.mfilter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c10150046.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) and c:IsType(TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c10150046.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function c10150046.matop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsType(TYPE_XYZ) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
		   Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c10150046.matfilter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER)
end
function c10150046.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150046.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10150046.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10150046.matfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	   local og=g:Select(tp,1,1,nil)
	   Duel.Overlay(c,og)
	end
end
function c10150046.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b) and not c:IsCode(10150046) and (c:GetRank()>=6 or c:GetLevel()>=6)
end
function c10150046.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10150046)==0 end
	Duel.RegisterFlagEffect(tp,10150046,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end