local m=53799020
local cm=_G["c"..m]
cm.name="恣情纵取而抛国弃民的圣人"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsAbleToRemove,nil):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsAbleToRemove,nil):Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(Card.IsRelateToEffect,nil,e)
	local sg=nil
	if g:GetCount()==0 then
	elseif g:GetCount()==1 then sg=g
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g:Select(tp,1,1,nil)
	end
	if #sg>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) and c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(0,LOCATION_HAND+LOCATION_GRAVE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(0,1)
	e5:SetValue(cm.actlimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0xff0000,0,1)
end
function cm.actlimit(e,re)
	return re:GetCode(EVENT_SPSUMMON_SUCCESS) and re:GetHandler():GetFlagEffect(m)>0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(9) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t1=false
	local t2=false
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsSummonPlayer(tp) then t1=true else t2=true end
	end
	if t1 and not t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
	elseif not t1 and t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	else Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,500) end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
	if dp~=PLAYER_ALL then Duel.Damage(dp,500,REASON_EFFECT)
	else
		Duel.Damage(tp,500,REASON_EFFECT,true)
		Duel.Damage(1-tp,500,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
