--幻影旅团·8 小滴
local m=45746008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(cm.f1,tp,LOCATION_MZONE,0,1,nil,ft)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.f1,tp,LOCATION_MZONE,0,1,1,nil,ft)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return r==REASON_XYZ and c:GetReasonCard():GetOriginalRace()==RACE_PSYCHO 
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local tc=Duel.GetFirstTarget()
			if c:IsRelateToEffect(e) then
				local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,TYPE_MONSTER):GetFirst()
				local og=tc:GetOverlayGroup()
				if not tc:IsImmuneToEffect(e) and og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,Group.FromCards(tc))
			end
		end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
	end)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.sf,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.sf,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end)
	c:RegisterEffect(e4)
end
function cm.f1(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x5880) and c:IsAbleToRemoveAsCost() and not c:IsCode(m) and (ft>0 or c:GetSequence()<5)
end
function cm.sf(c)
	return c:IsSetCard(0x5880) and c:IsSummonable(true,nil)
end