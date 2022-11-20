--赛德娜
function c10113085.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113085,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10113085.macost)
	e2:SetTarget(c10113085.matg)
	e2:SetOperation(c10113085.maop)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c10113085.macheck)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10113085,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c10113085.setcon)
	e4:SetTarget(c10113085.settg)
	e4:SetOperation(c10113085.setop)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e3)
end
function c10113085.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c10113085.setfilter(c,e,tp,fts,ftm)
	return (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and ftm>0) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (fts>0 or c:IsType(TYPE_FIELD))) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_LOST_TARGET) and c:IsCanBeEffectTarget(e)
end
function c10113085.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fts,ftm,og=Duel.GetLocationCount(tp,LOCATION_SZONE),Duel.GetLocationCount(tp,LOCATION_MZONE),e:GetLabelObject():GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and og:IsExists(c10113085.setfilter,1,nil,e,tp,fts,ftm) end
	if chk==0 then return og:IsExists(c10113085.setfilter,1,nil,e,tp,fts,ftm) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=og:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	if g:GetFirst():IsType(TYPE_MONSTER) then
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
	end
end
function c10113085.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		   Duel.ConfirmCards(1-tp,tc)
		end
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c10113085.macheck(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c10113085.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10113085.mafilter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN) and c:IsFaceup()
end
function c10113085.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c10113085.mafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113085.mafilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10113085.mafilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c10113085.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end