--幻影旅团·2 飞坦
local m=45746002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.t1,tp,LOCATION_DECK,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.t1,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x5880) end
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x5880)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x5880)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,2,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e3)

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
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
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
end
function cm.t1(c)
	return c:IsSetCard(0x5880) and c:IsSSetable() and c:IsType(TYPE_SPELL)
end
