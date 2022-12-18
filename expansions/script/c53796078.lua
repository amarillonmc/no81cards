local m=53796078
local cm=_G["c"..m]
cm.name="魔巫师酒饮"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,ft)
	return g:GetCount()<ft and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc~=c and cm.spfilter(chkc,e,tp) end
	local ft=Duel.GetMZoneCount(tp,e:GetHandler())
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,1,3,ft)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,tg:GetCount(),0,0)
end
function cm.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.spfilter2,nil,e,tp)
	if #g==0 then return end
	if #g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
