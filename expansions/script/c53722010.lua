local m=53722010
local cm=_G["c"..m]
cm.name="巫大祭环 烏"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c,rc)return 0xb0000+e:GetHandler():GetLevel()end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.thcon)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x3531) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.con(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,c,e,tp) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetMZoneCount(tp)>1
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	sg:AddCard(c)
	sg:Merge(g)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler()==Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x3531) and c:IsLevel(11) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,nil)
	if c:IsAbleToRemove() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.SetLP(tp,Duel.GetLP(tp)-400)
		end
	end
end
