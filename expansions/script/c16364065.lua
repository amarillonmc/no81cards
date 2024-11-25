--X抗体 芬里尔魔狼兽：建御雷神
function c16364065.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c16364065.mfilter,nil,5,5,c16364065.ovfilter,aux.Stringid(16364065,0))
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c16364065.regcon)
	e0:SetOperation(c16364065.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16364065,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(3)
	e1:SetCondition(c16364065.condition)
	e1:SetTarget(c16364065.target)
	e1:SetOperation(c16364065.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16364065,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16364065)
	e2:SetCost(c16364065.rmcost)
	e2:SetTarget(c16364065.rmtg)
	e2:SetOperation(c16364065.rmop)
	c:RegisterEffect(e2)
	--toextra
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16364065,3))
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16364065)
	e3:SetCondition(c16364065.tecon)
	e3:SetTarget(c16364065.tetg)
	e3:SetOperation(c16364065.teop)
	c:RegisterEffect(e3)
end
function c16364065.mfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0xdc3)
end
function c16364065.ovfilter(c)
	return c:IsFaceup() and c:IsCode(16364059) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,16364307)
end
function c16364065.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c16364065.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c16364065.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16364065.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(16364065) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c16364065.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
end
function c16364065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16364065.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c16364065.costfilter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
end
function c16364065.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16364065.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16364065.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16364065.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_ONFIELD)
end
function c16364065.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,2,2,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c16364065.tecon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	return ct1<ct2 and ct1>=5 and ct1<10
end
function c16364065.tefilter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function c16364065.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c16364065.tefilter,tp,LOCATION_GRAVE,0,10-ct1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,10-ct1,tp,LOCATION_GRAVE)
end
function c16364065.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c16364065.teop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c16364065.tefilter,tp,LOCATION_GRAVE,0,10-ct1,10-ct1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		local g1=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local g2=Duel.GetMatchingGroup(c16364065.tgfilter,tp,0,LOCATION_EXTRA,nil)
		if #g2>#g1 and Duel.SelectYesNo(tp,aux.Stringid(16364065,4)) then
			local tg=g2:RandomSelect(tp,#g1)
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end