local m=53729002
local cm=_G["c"..m]
cm.name="心化单元 岩"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+50)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,53729004,0x5533,TYPES_TOKEN_MONSTER,0,0,4,RACE_PYRO,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local flag=false
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,53729004,0x5533,TYPES_TOKEN_MONSTER,0,0,4,RACE_PYRO,ATTRIBUTE_DARK) then
		if ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and not Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsType(TYPE_LINK)end,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsLinkState() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then flag=true end
		local token=Duel.CreateToken(tp,53729004)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		cm.limit(token,e)
		if flag==true then
			local token=Duel.CreateToken(tp,53729004)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			cm.limit(token,e)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0x5533) and c:IsType(TYPE_LINK) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and eg:IsContains(chkc) and cm.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(cm.cfilter,1,nil,e,tp) end
	local g=eg:Filter(cm.cfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,e,tp):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
end
function cm.limit(c,e)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetValue(cm.splimit)
	c:RegisterEffect(e3,true)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4,true)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5,true)
end
function cm.splimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_PYRO)
end
