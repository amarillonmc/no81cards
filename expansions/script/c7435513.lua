--叛骨装骸 盖加斯芙蕾楼罗
local s,id,o=GetID()
--string
s.named_with_Rebellion_Skull=1
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
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
	
end
function s.mfilter(c)
	return c:IsLinkRace(RACE_ZOMBIE) and c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function s.lcheck(g,lc)
	return g:IsExists(s.mfilter,1,nil)
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and (s.Rebellion_Skull(te:GetHandler()) or s.Skullize(te:GetHandler()))
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
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
