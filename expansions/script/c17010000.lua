--形态转换
local m=17010000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,code,lv,e,tp,mc)
	return c:IsLevel(lv) and c:IsSetCard(0x7fa) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7fa)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),c:GetOriginalLevel(),e,tp,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	local lv=tc:GetOriginalLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,code,lv,e,tp,nil)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),4))
	if tc.KamenRider_name==17020110 then 
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,3))
	elseif tc.KamenRider_name==17020000 and tc:GetCode()~=17020060 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,2))
	elseif tc.KamenRider_name==17020070 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,4))
	elseif tc.KamenRider_name==17020000 and tc:GetCode()~=17020060 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,5))
	elseif tc.KamenRider_name==17020210 then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(17020120,6))
	end
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
		Duel.Hint(HINT_SOUND,0,aux.Stringid(tc:GetCode(),5))
	end
end
