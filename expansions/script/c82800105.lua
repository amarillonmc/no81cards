--永远亭 月之贤者八意永琳
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),7,3,s.ovfilter,aux.Stringid(id,0),3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSetCard(0x862)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(82800063)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return og and #og>0 and c:CheckRemoveOverlayCard(tp,#og,REASON_COST) end
	Duel.SendtoGrave(og,REASON_COST)
	Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,0,tp,tp,Duel.GetCurrentChain())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.rmfilter(c,d)
	return c:IsFaceup() and c:IsCode(d)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(s.distg)
	e1:SetLabel(ac)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	e2:SetLabel(ac)
	Duel.RegisterEffect(e2,tp)
	local sg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ac)
	if #sg>0 then 
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.distg(e,c)
	local ac=e:GetLabel()
	return c:IsCode(ac) and (c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsCode(ac)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
