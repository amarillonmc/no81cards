--誓约胜利之剑·原初
function c22022020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c22022020.ovfilter,aux.Stringid(22022020,0),3,c22022020.xyzop)
	c:EnableReviveLimit()
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c22022020.winop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022020,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22022020.thtg)
	e3:SetOperation(c22022020.thop)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022020,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22022020.cost)
	e3:SetTarget(c22022020.tgtg)
	e3:SetOperation(c22022020.tgop)
	c:RegisterEffect(e3)
	--Summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22022020,3))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c22022020.discon)
	e7:SetOperation(c22022020.rpop)
	c:RegisterEffect(e7)
end
function c22022020.cfilter(c)
	return c:IsSetCard(0x3ff1) and c:IsDiscardable()
end
function c22022020.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22022010)
end
function c22022020.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022020.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22022020.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22022020.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_GHOSTRICK_SPOILEDANGEL=0x1
	if e:GetHandler():GetOverlayCount()==13 then
		Duel.Win(tp,WIN_REASON_GHOSTRICK_SPOILEDANGEL)
	end
end
function c22022020.thfilter(c)
	return c:IsSetCard(0x2ff1) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR) and c:IsCanOverlay()
end
function c22022020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c22022020.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c22022020.thfilter,tp,LOCATION_GRAVE,0,nil)
end
function c22022020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22022020.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c22022020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,6,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,6,6,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22022021,0))
	Duel.SelectOption(tp,aux.Stringid(22022021,1))
	Duel.SelectOption(tp,aux.Stringid(22022021,2))
	Duel.Hint(HINT_CARD,0,22021440)
	Duel.SelectOption(tp,aux.Stringid(22022021,3))
	Duel.Hint(HINT_CARD,0,22021520)
	Duel.SelectOption(tp,aux.Stringid(22022021,4))
	Duel.Hint(HINT_CARD,0,22021040)
	Duel.SelectOption(tp,aux.Stringid(22022021,5))
	Duel.Hint(HINT_CARD,0,22021260)
	Duel.SelectOption(tp,aux.Stringid(22022021,6))
	Duel.Hint(HINT_CARD,0,22022030)
	Duel.SelectOption(tp,aux.Stringid(22022021,7))
	Duel.SelectOption(tp,aux.Stringid(22022021,8))
	Duel.Hint(HINT_CARD,0,22022010)
end
function c22022020.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c22022020.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22022021,9))
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function c22022020.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c22022020.rpfilter(c,e,tp)
	return c:IsCode(22022010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022020.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22022020.rpfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22022020,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
