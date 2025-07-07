--马纳利亚密友·安&古蕾雅
--cm.isSpellboost=true
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.incon)
	e1:SetTarget(cm.etg)
	e1:SetOperation(cm.eop)
	c:RegisterEffect(e1)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.spfil(c,e,tp)
	return c:IsCode(m+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spellfil(c)
	return c.isSpellboost
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spellfil,tp,LOCATION_HAND,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spellfil,tp,LOCATION_HAND,0,nil)
	if g then
		for tc in aux.Next(g) do
			for i=1,3 do
				if not tc:IsPublic() then
					local e11=Effect.CreateEffect(c)
					e11:SetType(EFFECT_TYPE_SINGLE)
					e11:SetCode(EFFECT_PUBLIC)
					e11:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e11)
				end
				tc:RegisterFlagEffect(60001538,RESET_EVENT+RESET_LEAVE+RESET_TODECK+RESET_TOGRAVE+RESET_REMOVE,0,1)
			end
		end
	end
end







