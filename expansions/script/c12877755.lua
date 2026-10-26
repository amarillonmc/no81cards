--极彩色的审判之矢
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(s.rmcon)
	e2:SetOperation(s.rmop2)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5A73)
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local rg=g:Filter(s.rmfilter,nil,tp)
	if chk==0 then return (e:IsCostChecked() or Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)) and #rg>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct2=Duel.GetFieldGroup(tp,0,LOCATION_DECK):FilterCount(s.rmfilter,nil,tp)
	local ct3=0
	if ct2>ct1 then ct3=ct1 end
	if ct2<=ct1 then ct3=ct2 end
	if ct3>0 then
		local rg=Duel.GetDecktopGroup(1-tp,ct3):Filter(s.rmfilter,nil,tp)
		Duel.DisableShuffleCheck()
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then
		Duel.Win(tp,0xa7)
	end
end
function s.rmcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPublic() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		s.rmop(e,tp,eg,ep,ev,re,r,rp)
	end
end