--幻想曲 被褪去的面具
function c60150530.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150530,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,60150530+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60150530.e1con)
	e1:SetTarget(c60150530.e1tg)
	e1:SetOperation(c60150530.e1op)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150530,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,6010530)
	e2:SetTarget(c60150530.e2tg)
	e2:SetOperation(c60150530.e2op)
	c:RegisterEffect(e2)
end
function c60150530.e1tgf(c,tp)
	return c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,1,REASON_SPSUMMON)
end
function c60150530.e1con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_SPSUMMON)
end
function c60150530.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c60150530.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c60150530.e1op(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	tc:RemoveOverlayCard(tp,1,1,REASON_SPSUMMON)
end
function c60150530.e2tgf(c)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60150530.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150530.e2tgf,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60150530.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150530.e2tgf,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end