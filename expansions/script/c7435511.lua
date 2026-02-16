--反叛的命运
local s,id,o=GetID()
--string
--s.named_with_Rebellion_Skull=1
--s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	--material
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return s.Rebellion_Skull(c)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and c:IsLocation(LOCATION_GRAVE) and c==e:GetHandler()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function s.thfilter(c)
	return (s.Rebellion_Skull(c) or s.Skullize(c)) and c:IsAbleToHand()
end
function s.thfilter2(c,tp)
	return (s.Rebellion_Skull(c) or s.Skullize(c)) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function s.filter(c,code)
	return c:IsCode(code)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
		--[[local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return h<5 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)]]
	end
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct=math.max(5-h,0)
	if ct>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function s.gcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and g:GetClassCount(Card.GetCode)==#g
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if h>=5 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g>0 then
		local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local ct=cg:GetClassCount(Card.GetCode)
		if Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) then ct=ct+1 end
		ct=math.min(ct,5-h)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,s.gcheck,false,ct,5-h)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
