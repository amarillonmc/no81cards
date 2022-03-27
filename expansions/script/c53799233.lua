local m=53799233
local cm=_G["c"..m]
cm.name="圣诞夜的归还 SRMY"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(4,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(function(c,tp)return c:IsAbleToDeck() and c:IsControler(tp) and Duel.GetMZoneCount(tp,c)>0 end,1,e:GetHandler(),tp) or not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) or not Duel.IsPlayerCanDraw(tp,1) then return end
	Duel.RegisterFlagEffect(tp,m+333,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,m+333)-Duel.GetFlagEffect(tp,m+666)==1 then Duel.RaiseEvent(eg,EVENT_CUSTOM+m,e,0,tp,tp,0) end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,m+666,RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c,e,tp)return c:IsRelateToEffect(e) and c:IsAbleToDeck() and c:IsControler(tp) and Duel.GetMZoneCount(tp,c)>0 end,e:GetHandler(),e,tp)
	local spg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #g==0 or #spg==0 or not Duel.IsPlayerCanDraw(tp,1) then return end
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=spg:Select(tp,1,1,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
