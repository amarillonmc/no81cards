local cm,m = GetID()
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_AQUA) or c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT) end,2,false)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,m+1)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rop)
	e1:SetValue(cm.rval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local tp = e:GetHandlerPlayer()
	if not Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
	    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.f(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToRemove() and (c:IsRace(RACE_AQUA) or c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT)) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.rf,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function cm.rval(e,c)
	return cm.rf(c,e:GetHandlerPlayer())
end
function cm.rf(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and (c:IsRace(RACE_AQUA) or c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT)) and not c:IsReason(REASON_REPLACE)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and rp==1-tp
end
function cm.ff(c,e,tp)
	return c:IsCode(46534755) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ff,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.ff,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
			if #sg>0 then
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end
