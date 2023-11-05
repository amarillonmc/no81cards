--海晶少女·软珊瑚
local m=11634002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
end
--link summon
function cm.mfilter(c)
	return c:IsLinkSetCard(0x12b) and c:GetLink()>=2
end
--Effect 1
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	return ec:IsSummonType(SUMMON_TYPE_LINK) 
end
function cm.sp(c,e,tp)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.hspcheck(g)
	Duel.SetSelectedCard(g)
	return g:FilterCount(Card.IsType,nil,TYPE_LINK)==0
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED 
	local mg=e:GetHandler():GetMaterial()
	if #mg==0 then return false end
	local lct=mg:GetSum(Card.GetLink)-1
	local b1=lct>0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.GetMatchingGroupCount(cm.sp,tp,loc,0,nil,e,tp)>0
	if chk==0 then return b1 and b2 and b3 end
	e:SetLabel(lct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sp),tp,loc,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:SelectSubGroup(tp,cm.hspcheck,false,1,e:GetLabel())
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	if e:GetLabel()+1>=3 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,m+1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,m+1)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end