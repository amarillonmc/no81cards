--星钢长枪
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,s.synfilter,aux.NonTuner(s.synfilter),1)
	c:EnableReviveLimit()
	--td
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(EFFECT_UPDATE_ATTACK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--re
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.remcost)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
end
function s.synfilter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_MONSTER)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_SYNCHRO)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT) then
	local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.remcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(s.refilter,tp,0,LOCATION_REMOVED,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,s.remfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,c):GetFirst()
	if g then
		Duel.SendtoDeck(c,tp,SEQ_DECKSHUFFLE,REASON_COST)
		Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_COST) 
	end 
end
function s.remfilter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsCode(79201021)
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end