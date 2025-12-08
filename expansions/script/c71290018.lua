--弦辉骑士 信
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfil1,4,2,cm.xyzfil2,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.xyzfil1(c)
	return c:IsType(TYPE_SPIRIT)
end
function cm.xyzfil2(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(71290011)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71290011)~=0 end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.fil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9623)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_GRAVE,0,1,nil) or c:GetOverlayCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local g=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_GRAVE,0,nil)
	local maxnum=math.min(#g,c:GetOverlayCount(),Duel.GetLocationCount(tp,LOCATION_SZONE))
	if maxnum==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tg=g:Select(tp,1,1,nil)
	local mg=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
			mg:AddCard(tc)
		end
	end
	if #mg~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tmg=mg:Select(tp,1,1,nil)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end

function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0x9623) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	elseif c:IsLocation(LOCATION_SZONE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end






