local m=53796025
local cm=_G["c"..m]
cm.name="新旧对决"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.GetTurnPlayer()==tp
end
function cm.filter(c,e,tp,eg)
	local t={}
	if c:GetLevel()>0 then table.insert(t,c:GetLevel()) end
	if c:GetRank()>0 then table.insert(t,c:GetRank()) end
	if c:GetLink()>0 then table.insert(t,c:GetLink()) end
	return eg:IsContains(c) and Duel.IsExistingMatchingCard(cm.spf,tp,LOCATION_EXTRA,0,1,nil,e,tp,t)
end
function cm.spf(c,e,tp,tb)
	local res=false
	local t={c:GetLevel(),c:GetRank(),c:GetLink()}
	for i=1,#t do if SNNM.IsInTable(t[i],tb) then res=true end end
	return res and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,eg) end
	if eg:GetCount()==1 then Duel.SetTargetCard(eg) else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local t={}
	if tc:GetLevel()>0 then table.insert(t,tc:GetLevel()) end
	if tc:GetRank()>0 then table.insert(t,tc:GetRank()) end
	if tc:GetLink()>0 then table.insert(t,tc:GetLink()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.spf,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,t)
	if #g==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)==0 then return end
	if not c:IsRelateToEffect(e) or not g:GetFirst():IsType(TYPE_XYZ) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.Overlay(g:GetFirst(),Group.FromCards(c))
end
