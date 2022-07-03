local m=31400079
local cm=_G["c"..m]
cm.name="近神的龙熊"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.advcon)
	e1:SetOperation(cm.advop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.extfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsReleasable()
end
function cm.advcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	return c:IsLevelAbove(7) and minc<=2 and mg:FilterCount(cm.extfilter,nil)>2
end
function cm.advop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local reg=mg:Filter(cm.extfilter,nil):Select(tp,2,2,nil)
	c:SetMaterial(reg)
	Duel.SendtoGrave(reg,REASON_SUMMON+REASON_MATERIAL+REASON_RELEASE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	local tgc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.ConfirmCards(tp,tgc1)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	if not tgc1:IsLocation(LOCATION_GRAVE) then return end
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	local tgc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	Duel.ConfirmCards(tp,tgc2)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	if not tgc2:IsLocation(LOCATION_GRAVE) then return end
	local exg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #exg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	Duel.ConfirmCards(tp,exg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(exg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil),REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)
end