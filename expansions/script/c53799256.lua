local m=53799256
local cm=_G["c"..m]
cm.name="无伞"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+500,RESET_PHASE+PHASE_END,0,2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	if Duel.GetFlagEffect(1-tp,m+500)-Duel.GetFlagEffect(1-tp,m)>7 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.op)
		Duel.RegisterEffect(e1,tp)
	else
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount()+2)
		e2:SetCondition(cm.con)
		e2:SetOperation(cm.op)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c,e,tp)return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)end,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if #g==0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE)>=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetOperation(cm.sumop)
	g:GetFirst():RegisterEffect(e1,true)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(function(e,rp,tp)return tp==rp end)
end
