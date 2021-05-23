--次元震荡机
local m=30003055
local cm=_G["c"..m]
function cm.initial_effect(c)
   aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,4,cm.lcheck) 
	c:EnableReviveLimit()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,0,nil)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
		if chk==0 then return mg:GetCount()==sg:GetCount() and mg:GetCount()>0 end
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)>=5 then
			e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_COST)
						local e0=Effect.CreateEffect(e:GetHandler())
						e0:SetType(EFFECT_TYPE_FIELD)
						e0:SetCode(EFFECT_CANNOT_REMOVE)
						e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
						e0:SetTargetRange(1,1)
						e0:SetTarget(aux.TargetBoolFunction(Card.IsControler,tp))
						e0:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e0,tp)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			if Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+100)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
						local e0=Effect.CreateEffect(e:GetHandler())
						e0:SetType(EFFECT_TYPE_FIELD)
						e0:SetCode(EFFECT_CANNOT_REMOVE)
						e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
						e0:SetTargetRange(1,1)
						e0:SetTarget(aux.TargetBoolFunction(Card.IsControler,tp))
						e0:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e0,tp)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
					Duel.SpecialSummon(g,nil,tp,tp,false,false,POS_FACEUP)
		end
	end)
	c:RegisterEffect(e3)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsCode,1,nil,30003035)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and (c:IsCode(30003035) or c:IsCode(30003045))
end