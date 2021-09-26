--幻影旅团·10 剥落列夫
local m=45746010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.t1,tp,LOCATION_HAND,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		local g=Duel.GetMatchingGroup(cm.t1,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.t1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+100)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.t1,tp,LOCATION_GRAVE,0,1,nil,e,tp)end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(cm.t1,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.t1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e3:SetValue(1)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOriginalRace()==RACE_PSYCHO
	end)
	c:RegisterEffect(e3)
end
function cm.t1(c,e,tp)
	return c:IsSetCard(0x5880) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end