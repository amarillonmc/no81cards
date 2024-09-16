--千古一帝
local m = 22020460
local cm = _G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,22020460)
	aux.AddCodeList(c,22020440)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,22020440))
	e2:SetValue(2500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Effect Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end
function cm.resfilter(c,tp)
	return c:IsReleasableByEffect() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.gcheck(g,e,tp)
	return g:GetClassCount(Card.GetAttribute) == #g and Duel.GetMZoneCount(tp,g,tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCode(22020440) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and not c.mat_filter 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.resfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return g:CheckSubGroup(cm.gcheck,6,6,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,6,0,0)
	Duel.SelectOption(tp,aux.Stringid(22020460,1))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function cm.activate(e,tp)
	local g=Duel.GetMatchingGroup(cm.resfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,cm.gcheck,false,6,6,e,tp)
	if #rg<=0 or Duel.Release(rg,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not sc or Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)<=0 then return end
	sc:CompleteProcedure()
	local dct = 6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if og:FilterCount(cm.cfilter,nil,tp)==6 and dct>0 and Duel.IsPlayerCanDraw(tp,dct) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,dct,REASON_EFFECT)
	end
end