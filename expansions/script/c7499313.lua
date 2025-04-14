--艺形虫 野兽F-F-05
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(s.ArtlienWorm),2,63,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.matcheck)
	c:RegisterEffect(e2)
	--field effect-add setcard?
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.fetg)
	e3:SetValue(id)
	c:RegisterEffect(e3)
	--field effect-remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	--e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.fetg)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--hint
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(id)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.fetg)
	c:RegisterEffect(e5)
	--effect gain
	--[[local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,11))
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(s.fetg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)]]
	if not s.global_effect then
		s.global_effect=true
		--effect gain
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(id,11))
		e7:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetRange(LOCATION_MZONE)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetTarget(s.fetg2)
		e6:SetLabelObject(e7)
		Duel.RegisterEffect(e6,tp)
	end
end
function s.fetg2(e,c)
	return c:IsHasEffect(id) and c:IsFaceup()
end
function s.costfilter(c)
	return s.ArtlienWorm(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
function s.thfilter(c,chk)
	return chk==1 and s.ArtlienWorm(c) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) or chk==2 and c:IsOnField()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_MZONE,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,s.thfilter,1,2) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,s.thfilter,1,2)
	if tg:GetCount()~=2 then return end
	Duel.HintSelection(tg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function s.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function s.seqfilter(c,ec)
	return math.abs(aux.GetColumn(c,0)-aux.GetColumn(ec,0))==1
end
function s.fetg(e,c)
	return s.seqfilter(c,e:GetHandler()) and c:IsLocation(LOCATION_MZONE)
end
