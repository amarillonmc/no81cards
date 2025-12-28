--舍沙
local m=11513087
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513087,0)) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c11513087.opspcon)
	e1:SetOperation(c11513087.opspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513087,1)) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCondition(c11513087.sfspcon)
	e2:SetOperation(c11513087.sfspop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c11513087.target)
	e3:SetOperation(c11513087.operation)
	c:RegisterEffect(e3)
	
end
function c11513087.spfilter1(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(1-tp,c)>0
end
function c11513087.spfilter2(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c11513087.opspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c11513087.spfilter1,tp,0,LOCATION_ONFIELD,1,nil,tp)
end
function c11513087.sfspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c11513087.spfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c11513087.sfspop(e,tp,eg,ep,ev,re,r,rp,c)
	return c11513087.spsel(e,tp,c,tp)
end
function c11513087.opspop(e,tp,eg,ep,ev,re,r,rp,c)
	return c11513087.spsel(e,tp,c,1-tp)
end
function c11513087.fselect(g,mp,sc)
	return g:FilterCount(Card.IsControler,nil,mp)-g:FilterCount(Card.IsControler,nil,1-mp)==1
end
function c11513087.spsel(e,tp,c,mp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=sg:SelectSubGroup(tp,c11513087.fselect,false,1,23,mp,c)
	local atk=g:GetCount()*1000
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(11513087,RESET_EVENT+0xff0000,0,1,g:GetCount())
end
function c11513087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c11513087.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetFlagEffectLabel(11513087) then return false end
	local ct=c:GetFlagEffectLabel(11513087)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		local ctt=Duel.SendtoGrave(g,REASON_EFFECT)
		if ctt>0 then
			Duel.Draw(tp,ctt,REASON_EFFECT)
		end
	end
end












