--崩星龙华-沌巴
local m=11513090
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11513090.sprcon)
	e2:SetTarget(c11513090.sprtg)
	e2:SetOperation(c11513090.sprop)
	c:RegisterEffect(e2)
	--cannot fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,11513090)
	e4:SetTarget(c11513090.settg)
	e4:SetOperation(c11513090.setop)
	c:RegisterEffect(e4)
	--apply
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,11514090)
	e5:SetCondition(c11513090.opcon)
	e5:SetTarget(c11513090.optg)
	e5:SetOperation(c11513090.opop)
	c:RegisterEffect(e5)
	
end
function c11513090.sprfilter(c)
	return c:IsFaceupEx() and c:IsAbleToDeckOrExtraAsCost() and c:IsLevelAbove(0)
end
function c11513090.fselect(g,tp,sc)
	if not aux.gffcheck(g,Card.IsFusionSetCard,0x1c0,Card.IsRace,RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM)
		or Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	return true
end
function c11513090.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11513090.sprfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,nil)
	return g:CheckSubGroup(c11513090.fselect,2,2,tp,c)
end
function c11513090.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11513090.sprfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c11513090.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11513090.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c11513090.setfilter(c)
	return c:IsSetCard(0x1c0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c11513090.tthfilter2(c)
	return c:IsSetCard(0x1c0) and c:IsAbleToHand()
end
function c11513090.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11513090.setfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and #g>0 and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c11513090.tthfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11513090.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11513090.tthfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
			if (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) or not c:IsRelateToEffect(e) then return end
			if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
				c:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
	end
end
function c11513090.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1c0)
end
function c11513090.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11513090.thfilter,1,nil)
end
function c11513090.tthfilter(c)
	return c:IsSetCard(0x1c0) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11513090.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513090.tthfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11513090.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11513090.tthfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end